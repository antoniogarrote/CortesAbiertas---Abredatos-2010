class Session < ActiveRecord::Base
  has_many :interventions
  has_many :session_words

  def to_hash
    { :id => id,
      :identifier => identifier,
      :date => date,
      :content => content,
      :day_order => day_order,
      :interventions => interventions.map(&:to_hash),
      :words_json => session_words.map(&:to_hash) }
  end

  def to_json
    to_hash.to_json
  end

  def orators
    interventions.collect{|i| i.parliament_member}.uniq
  end

  def day_order_bullets
    Session.first.day_order.split(/\s*\d+\.([\d\.])*\s*/).reject{|p| p == "" || p=="."}
  end

  def all_top_words(limit=3)
    session_words.find(:all, :conditions => ["count > ?", 10], :limit => limit , :order => "count DESC")
  end

  def all_top_nouns(limit=3)
    session_words.find(:all, :conditions => ["count > ? AND pos=?", 10,"NC"], :limit => limit , :order => "count DESC")
  end

  def all_top_verbs(limit=3)
    session_words.find(:all, :conditions => ["count > ? AND pos=?", 10,"VLfin"], :limit => limit , :order => "count DESC")
  end

  def all_top_adjs(limit=3)
    session_words.find(:all, :conditions => ["count > ? AND pos=?", 10,"ADJ"], :limit => limit , :order => "count DESC")
  end

  def self.dump_js(filename)
    debugger
    js = StringIO.new
    js << "SessionDataCortesAbiertas = {"
    Session.all.each_with_index do |s,i|
      if i != 0
        js << " , "
      end
      js << "session_#{s.id}: "
      js << s.all_top_words.map{ |w| w.to_hash }
    end
    js << "}"

    File.open(filename,"w") do |f|
      f << js.string
    end
  end
end
