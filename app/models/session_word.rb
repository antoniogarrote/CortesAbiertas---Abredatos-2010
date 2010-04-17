class SessionWord < ActiveRecord::Base
  include JsonWord::ToInclude
  extend JsonWord::ToExtend

  belongs_to :session
end
