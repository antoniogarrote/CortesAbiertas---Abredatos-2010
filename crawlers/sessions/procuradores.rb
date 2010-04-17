# -*- coding: utf-8 -*-
require 'jcode'
$KCODE='u'

require 'rubygems'
require 'yaml'
require 'anemone'
require 'nokogiri'
require 'harmony'
require 'ruby-debug'

class Procurador
  attr_accessor :valid,:circunscripcion, :grupo, :name, :cargos
  def initialize(html)
    datos = html.xpath("//div[@class='col_media_derecha']")

	
    @name = datos.select{ |datos| !datos.xpath("h2").empty? }.first.xpath("h2").first.text
    @grupo = datos.xpath("p")[0].text
	@circunscripcion = datos.xpath("//div[@class='col_media_derecha']/p").collect{ |p| p.content }[1]
	@cargos = datos.xpath("ul")[1].xpath("li").text
  end
  def to_yml
    {
       :name => @name,
       :grupo => @grupo,
       :circunscripcion => @circunscripcion,
	   :cargos => @cargos
    }
  end

end

# Start url

URL = "http://www.ccyl.es/cms/composicion/procuradores/"
# User agent for the crawler
UA = "Mozilla/5.0 (Windows; U; MSIE 7.0; Windows NT 6.0; es-ES)"
# Patterns
#javascript:AbrirVentana('Datos','HTMPublicacion.asp?Leg=7&Serie=DS(P)&Numero=90')
INITIATIVE_PATTERN = "?param1=alfabetico&param2=[a-zA-Z]"
# File constants
STORE_FILE = "links.pstore"
DUMP_FILE = "procuradores.yml"

begin
  # Make sure that the first option is a URL we can crawl
  # and have a valid serie format

  root = "http://www.ccyl.es/cms/composicion/procuradores/"
  pattern = /INITIATIVE_PATTERN/
rescue
  puts <<-INFO
Usage:
ruby sy_crawler.rb <url>
INFO
  exit(0)
end

# Starts crawling process
Anemone.crawl(root,:verbose => true) do |anemone|

  # TODO: Use PStore to reduce the amount of memory
  procuradores = []

  # Focus crawler to follow series or episodes urls
  anemone.focus_crawl do |page|
    links = page.links.select { |link| link.to_s =~ /http:\/\/www.ccyl.es\/cms\/composicion\/procuradores\/\?param1=alfabetico(.*)/ }
    #puts links
	#    links = page.body.scan(/\?param1=alfabetico&param2=[a-zA-Z]/).map{ |l| URI("http://www.ccyl.es/cms/composicion/procuradores/" + l) }
    links
  end

  count = 0

  anemone.on_pages_like(/codigoPersona/) do |page|
	
    #count += 1

    #if count < 3

      print "."
		
      session = begin
                  Procurador.new(page.doc)
                rescue Exception => ex
                  puts ex.message
                  print "!"
                  nil
                end
      procuradores << session unless session.nil?

    #else
    #  print "_"
    #end
  end

  
   # Dump information
  anemone.after_crawl do |page|
    File.open(DUMP_FILE, 'w') do |f|
      obj = procuradores.collect do |s|
        # Serialize
        s.to_yml
      end

      YAML.dump(obj, f)
    end
  end


end
