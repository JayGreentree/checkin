class CheckinSession < ActiveRecord::Base
  belongs_to :checkin_session_type
  has_many :checkin_session_owners, dependent: :destroy
  has_many :checkins, class_name: "CheckinUser", :dependent => :restrict_with_error
end
