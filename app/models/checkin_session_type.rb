class CheckinSessionType < ActiveRecord::Base
  has_many :checkin_sessions, :dependent => :restrict_with_error
end
