class CheckinUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :checkin_session
end
