class ParliamentMember < ActiveRecord::Base
  has_many :interventions

  validates_uniqueness_of :name
  validates_presence_of :name

  def to_hash
    decoded_words_json = ActiveSupport::JSON.decode(words_json)
    {"name" => name, "words_json" => decoded_words_json}
  end

  def to_json
    to_hash.to_json
  end
end
