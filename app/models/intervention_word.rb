class InterventionWord < ActiveRecord::Base
  include JsonWord::ToInclude
  extend JsonWord::ToExtend

  belongs_to :intervention
end
