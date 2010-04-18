class Intervention < ActiveRecord::Base
  belongs_to :parliament_member
  belongs_to :session
  has_many :intervention_words

  def to_hash
    { :parliament_member_id => parliament_member_id,
      :date => date,
      :content => content,
      :sequence => sequence || -1,
      :session_id => session.id,
      :session_identifier => session.identifier,
      :parliament_member => parliament_member.to_hash,
      :words_json => session_words.select{|w| w.relevant }.map(&:to_hash) }
  end

  def to_json
    to_hash.to_json
  end
end
