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

end
