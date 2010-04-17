class ParliamentMemberWord < ActiveRecord::Base
  include JsonWord::ToInclude
  extend JsonWord::ToExtend

  belongs_to :parliament_member
end
