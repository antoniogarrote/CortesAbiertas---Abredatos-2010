class Intervention < ActiveRecord::Base
  belongs_to :parliament_member
  belongs_to :session

  def to_hash
    decoded_words_json = ActiveSupport::JSON.decode(words_json)
    { :parliament_member_id => parliament_member_id,
      :date => date,
      :content => content,
      :sequence => sequence || -1,
      :session_id => session.id,
      :session_identifier => session.identifier,
      :parliament_member => parliament_member.to_hash,
      :words_json => decoded_words_json }
  end

  def to_json
    to_hash.to_json
  end
end
