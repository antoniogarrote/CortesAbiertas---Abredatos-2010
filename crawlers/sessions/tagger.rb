# -*- coding: utf-8 -*-

require 'jcode'
$KCODE='u'

require 'rubygems'
require 'yaml'
require 'anemone'
require 'nokogiri'
require 'harmony'
require 'ruby-debug'

require 'net/http'
require 'uri'
require 'json'
require 'mongo'
require 'uuid'

TAGGER_SERVER = "http://localhost:8080/NLPServer/textExtractor"

class String
  def self.gatelize(str)
    str = str.gsub("á","a").gsub("é","e").gsub("í","i").gsub("ó","o").gsub("ú","u")
    str = str.gsub("Á","A").gsub("É","E").gsub("Í","I").gsub("Ó","O").gsub("Ú","U")
    str.gsub("ñ","n").gsub("Ñ","N")
  end
end

class Date
  def to_gm_time
    to_time(new_offset, :gm)
  end

  def to_local_time
    to_time(new_offset(DateTime.now.offset-offset), :local)
  end

  private
  def to_time(dest, method)
    #Convert a fraction of a day to a number of microseconds
    usec = (dest.send(:sec_fraction) * 60 * 60 * 24 * (10**6)).to_i
    Time.send(method, dest.send(:year), dest.send(:month), dest.send(:day), dest.send(:hour), dest.send(:min),
              dest.send(:sec), usec)
  end
end

module Taggable
  CHUNK_SIZE = 200

  def tag_me(content)
    print "."
    total = content.length
    num_chunks = (total / CHUNK_SIZE).to_i
    init = 0
    tags = []

    (0..num_chunks).each do |chunk|
      print ","
      if (init < total)
        end_pos = init + CHUNK_SIZE
        end_pos = total if end_pos > total
        while content[end_pos..end_pos] != " " && end_pos < total
          end_pos += 1
        end
        url = URI.parse(TAGGER_SERVER)
        begin
          req = Net::HTTP::Post.new(url.path)

          #req.body = session.content
          req.body = String.gatelize(content[init..end_pos])
          init = end_pos

          req.add_field('Content-Type','content="text/html; charset=utf-8')
          http = Net::HTTP.new(url.host, url.port)
          http.read_timeout = 30000000
          res = http.start {|http| http.request(req) }
          case res
          when Net::HTTPSuccess, Net::HTTPRedirection
            #puts res.body
            tmp = JSON.parse(res.body)
            tmp.each do |t|
              found = tags.detect{ |st| st['pos']  == t['pos'] && t['stem'] == st['stem'] }
              if found
                found['count'] += t['count']
              else
                tags << t
              end
            end
          else
            res.error!
          end
        rescue Exception => ex
          []
        rescue Timeout::Error => e
          puts content
          []
        end
      end
    end

    tags
  end
end


class Session

  include Taggable

  attr_accessor :valid, :id, :text, :day_order, :interventions, :date, :key, :words, :mongo
  def initialize(html=nil)
    unless html.nil?
      datos = html.xpath("//div[@id='Datos']")

      ds = datos.xpath("table/tr/td[@class='texto']")

      @id = ds.select{ |ds| !ds.xpath("strong").empty? }.first.xpath("strong").first.text
      @text = datos.xpath("table/tr/td[@class='texto']")[-2].text

      @day_order = DayOrder.new(html)
      @date = @id.match(/[0-9]+-[0-9]+-[0-9]+/).to_s
      parts = @date.split("-")
      @date = Date.parse(parts[2] + "." + parts[1] + "." + parts[0]).to_local_time

      @interventions = html.xpath("//div[@class='Inter']").collect{ |i| int = Intervention.new(i); int.date = @date; int }
    end
  end

  def content
    @text + "\r\n\r\n" + @day_order.content + "\r\n\r\n" + @interventions.map(&:content).join("\r\n")
  end

  def tags
    acum = []
    @interventions.each do |int|
      tmp = int.tags
      tmp.each do |w|
        begin
          inserted = acum.detect{ |ow| w["stem"] == ow["stem"] }
          if inserted
            inserted["count"] += w["count"].to_int
          else
            acum << w
          end
        rescue Exception => ex
          puts "Exception!"
        end
      end
    end
    acum
  end

  def relevant_words db
    words = []
    ws = db.collection(@mongo['words']).find()
    all_words_collection = db.collection("words")
    ws.each do |w|
      found = all_words_collection.find_one("stem" => w['stem'], "pos" => w['pos'])
      words << w unless found
    end
    words
  end

  def all_words_from_mongo db
    words = []
    ws = db.collection(@mongo['words']).find()
    ws.each do |w|
      words << w
    end
    words
  end


  def to_mongo(db)
    print "S"
    coll = db.collection("sessions")
    collInts = db.collection("interventions")
    key = id.downcase.gsub(" ","")
    s = coll.find_one("key" => key)
    interventions = "interventions#{UUID.generate}"
    words = "words#{UUID.generate}"
    collThisWords = db.collection(words)

    keysInt = []
    @interventions.each do |int|
      tags = int.tags
      keyInt = int.to_mongo(db)
      keysInt << keyInt
      collInts.insert("orator" => int.orator, "date" => int.date, "key" => keyInt, "session" => key)
      tags.each do |word|
        w = Word.new(word)
        w.to_mongo(collThisWords)
      end
    end

    if s.nil?
      coll.insert("key" => key, "interventions" => keysInt, "words" => words,
                  "id" => @id, "date" => @date)
    end

  end

  def self.all_from_mongo(db)
    coll = db.collection("sessions")
    res = coll.find()
    sessions = []
    res.each do |r|
      sessions << from_mongo(db,r)
    end
    sessions
  end

  def self.from_mongo(db,r)
    s = Session.new
    s.key = r["key"]
    s.id = r["id"]
    s.date = r["date"]
    s.mongo = r

    wordsColl = db.collection(r["words"])
    s.words = []
    words = wordsColl.find().each do |w|
      s.words << Word.from_mongo(w)
    end
    s
  end
end

class DayOrder
  attr_accessor :points
  def initialize(html)
    @ods = html.xpath("//p[@class='ods']").collect{|ods| ods.text}.join(" ")
  end

  def content
    @ods
  end
end

class Intervention

  include Taggable
  include Mongo

  attr_accessor :orator, :text, :tags, :date

  def initialize(html)
    @orator = html.xpath("p[@class='Orador']").first.text.gsub("(","").gsub(")","").gsub(":","")
    parts = @orator.split(" ")
    @orator = parts[-2..-1].join(" ")

    @text = html.xpath("p[@class='normal']").collect{ |p| p.text }.join(" ").gsub("[aplausos]","").gsub("[Aplausos]","")
  end

  def content
    @text
  end

  def tags
    @tags = tag_me(@text)
    @tags
  end

  def to_mongo(db)
    print "i"
    mp = MemberParliament.new(@orator)
    mpMongo = mp.to_mongo(db)
    interventionsMp = db.collection(mpMongo["interventions"])
    wordsMp = db.collection(mpMongo["words"])
    words = db.collection("words")

    key = "internvention#{UUID.generate}"
    wordsInt = db.collection(key)
    if @tags
      @tags.each do |word|
        w = Word.new(word)
        w.to_mongo(interventionsMp)
        w.to_mongo(wordsMp)
        w.tag["date"] = @date || Time.now
        w.to_mongo(words)
      end
    end

    key
  end

end

class Word
  attr_accessor :tag, :mongo

  def initialize(tag=nil)
    @tag = tag if tag
  end

  def self.from_mongo(data)
    w = Word.new
    h = { "count" => data["count"],
      "stem" => data["stem"],
      "pos" => data["pos"],
      "literal" => data["literal"],
      "lemma" => data["lemma"],
      "date" => data["date"] }

    w.tag = h
    w.mongo = data
    w
  end

  def stop?
    @mongo && @mongo['stop']
  end

  def to_mongo(collection)
    print "."
    w = collection.find_one("stem" => @tag["stem"], "pos" => @tag["pos"])
    if w
      old = w["count"]
      w["count"] = old + @tag["count"]
      collection.save(w)
    else
      collection.insert(@tag)
    end
  end

  def self.all_from_mongo(db)
    words = []
    db.collection("words").find().each do |w|
      words << Word.from_mongo(w)
    end
    words
  end

  def self.mark_common_stop_words(db)
    words = self.all_from_mongo(db)
    sessions_count = db.collection("sessions").count()

    max = (sessions_count * 8 /10).to_i
    max = 2 if max == 1
    sessions = Session.all_from_mongo(db)

    words.each do |w|
      found = 0
      if w.tag['count'] < 10
        # db.collection("words").save(w.mongo.merge("stop" => true))
      else
        sessions.each do |s|
          res = s.words.detect do |wp|
            (wp.tag['stem'] == w.tag['stem'] && wp.tag['pos'] == w.tag['pos'])
          end
          found += 1 if res
        end
        if found >= max
          db.collection("words").save(w.mongo.merge("stop" => true))
        end
      end
    end
  end
end

class MemberParliament
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_mongo(db)
    print "mp"
    coll = db.collection("members_parliament")
    key = name.downcase.gsub(" ","")
    mp = coll.find_one("key" => key)
    if mp.nil?
      wordsCol = "wordsmp#{UUID.generate}"
      interventionsCol = "interventionscol#{UUID.generate}"
      coll.insert("name" => @name, "key" => key, "words" => wordsCol, "interventions" => interventionsCol)
      coll.find_one("key" => key)
    else
      mp
    end
  end
end

# {"count"=>2, "literal"=>"levanta", "lemma"=>"levantar", "stem"=>"levant", "pos"=>"VLfin"},
# main::IO

db = Mongo::Connection.new.db("cortes_abiertas")


sessions = YAML::load(File.open("sessions.yml","r"))
sessions_finished = YAML::load(File.open("finished.yml","r"))

debugger


sessions[0..20].each do |session|
  id = session.id
  if sessions_finished.include? id
    puts "#{id} ya insertado"
  else
    puts "TOTAL: #{session.tags.length}"
    session.tags.sort{ |a,b| a["count"] <=> b["count"] }.each do |w|
      puts "#{w['literal']} #{w['lemma']}: #{w['count']} (#{w['pos']})"
    end
    puts "----------------------------------------------------------"
    puts "Salvando en Mongodb"
    session.to_mongo(db)

    puts "Salvado!"

    sessions_finished << id
    File.delete("finished.yml")
    File.open("finished.yml","w") do |f|
      YAML.dump(sessions_finished,f)
    end
    puts "updated finished.yml"
  end
end


debugger
# Word.mark_common_stop_words db
# sessions = Session.all_from_mongo(db)
#ws = Word.all_from_mongo(db)

# s = Session.all_from_mongo(db).first
# ws = s.relevant_words(db)
# aws = s.all_words_from_mongo(db)

# puts "#{ws.length} vs #{aws.length}"
debugger
puts "ok"
