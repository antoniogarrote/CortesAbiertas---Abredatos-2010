class Session < ActiveRecord::Base
  has_many :interventions

  def to_hash
    decoded_words_json = ActiveSupport::JSON.decode(words_json)
    { :id => id,
      :identifier => identifier,
      :date => date,
      :content => content,
      :day_order => day_order,
      :interventions => interventions.map(&:to_hash),
      :words_json => decoded_words_json }
  end

  def to_json
    to_hash.to_json
  end
end
