class CheckinSession < ActiveRecord::Base
  belongs_to :checkin_session_type
  has_many :checkin_session_owners, dependent: :destroy
  has_many :checkins, class_name: "CheckinUser", :dependent => :restrict_with_error
  has_many :users, through: :checkins

  scope :today, -> { where(check_in_by: (Time.now.midnight - 1.day)..Time.now) }
  scope :current, -> { where("check_in_by >= ?", Time.now.yesterday.end_of_day).order( check_in_by: :asc) }
end
