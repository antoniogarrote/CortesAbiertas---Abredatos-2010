class ParliamentMember < ActiveRecord::Base

  has_many :interventions
  has_many :parliament_member_words

  validates_uniqueness_of :name
  validates_presence_of :name

  def to_hash
    {"name" => name,
      "words_json" => intervention_words.map(&:to_hash) }
  end

  def to_json
    to_hash.to_json
  end
end
