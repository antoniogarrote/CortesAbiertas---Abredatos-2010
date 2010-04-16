# -*- coding: utf-8 -*-
require 'jcode'
$KCODE='u'

require 'rubygems'
require 'yaml'
require 'anemone'
require 'nokogiri'
require 'harmony'
require 'ruby-debug'

class Session
  attr_accessor :valid, :id, :text, :day_order, :interventions
  def initialize(html)
    datos = html.xpath("//div[@id='Datos']")

    ds = datos.xpath("table/tr/td[@class='texto']")

    @id = ds.select{ |ds| !ds.xpath("strong").empty? }.first.xpath("strong").first.text
    @text = datos.xpath("table/tr/td[@class='texto']")[-2].text

    @day_order = DayOrder.new(html)
    @interventions = html.xpath("//div[@class='Inter']").collect{ |i| Intervention.new(i) }
  end
end

class DayOrder
  attr_accessor :points
  def initialize(html)
    @ods = html.xpath("//p[@class='ods']").collect{|ods| ods.text}.join(" ")
  end
end

class Intervention
  attr_accessor :orator, :text
  def initialize(html)
    @orator = html.xpath("p[@class='Orador']").first.text.gsub("(","").gsub(")","").gsub(":","")
    parts = @orator.split(" ")
    @orator = parts[-2..-1].join(" ")

    @text = html.xpath("p[@class='normal']").collect{ |p| p.text }.join(" ").gsub("[aplausos]","").gsub("[Aplausos]","")
  end
end

# Start url

URL = "http://2004.ccyl.es/POCCYL/"
# User agent for the crawler
UA = "Mozilla/5.0 (Windows; U; MSIE 7.0; Windows NT 6.0; es-ES)"
# Patterns
#javascript:AbrirVentana('Datos','HTMPublicacion.asp?Leg=7&Serie=DS(P)&Numero=90')
INITIATIVE_PATTERN = "javascript:AbrirVentana\('Datos','[a-zA-Z\.\?=0-9&\(\)]+'\)"
EPISODE_PATTERN = "#{URL}\/capitulo\/.*\/(.*)\/\\d+\/"
# File constants
STORE_FILE = "links.pstore"
DUMP_FILE = "sessions.yml"

begin
  # Make sure that the first option is a URL we can crawl
  # and have a valid serie format

  root = "http://2004.ccyl.es/POCCYL/Diario.asp?Leg=7"
  pattern = /INITIATIVE_PATTERN/
rescue
  puts <<-INFO
Usage:
ruby sy_crawler.rb <url>
INFO
  exit(0)
end

# Starts crawling process
Anemone.crawl(root, :storage => Anemone::Storage.PStore(STORE_FILE), :verbose => true) do |anemone|

  # TODO: Use PStore to reduce the amount of memory
  sessions = []

  # Focus crawler to follow series or episodes urls
  anemone.focus_crawl do |page|
    links = page.body.scan(/javascript:AbrirVentana\('Datos','[a-zA-Z\.\?=0-9&\(\)]*/).map{ |l| "http://2004.ccyl.es/POCCYL/" + l.split("','").last }.select{ |l| l.index("HTMPub") }.map{ |l| URI(l) }
    puts links
    links
  end

  count = 0

  anemone.on_pages_like(/HTMPub/) do |page|

    #count += 1

    #if count < 3

      print "."

      session = begin
                  Session.new(page.doc)
                rescue Exception => ex
                  puts ex.message
                  print "!"
                  nil
                end
      sessions << session unless session.nil?

    #else
    #  print "_"
    #end
  end

  anemone.after_crawl do
    puts sessions.length
    File.open(DUMP_FILE,'a') do |f|
      YAML.dump(sessions,f) unless sessions.empty?
    end
  end

end
