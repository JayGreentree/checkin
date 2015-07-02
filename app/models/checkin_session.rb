class CheckinSession < ActiveRecord::Base
  belongs_to :checkin_session_type
  has_many :checkin_session_owners, dependent: :destroy

  has_many :checkins, class_name: "CheckinUser", :dependent => :restrict_with_error
  has_many :on_time_checkins, -> (checkin_session){ on_time( checkin_session.check_in_by ) },
           class_name: "CheckinUser"
  has_many :late_checkins, -> (checkin_session){ late( checkin_session.check_in_by ) },
           class_name: "CheckinUser"
  has_many :missing_checkins, -> { missing }, class_name: "CheckinUser"
  has_many :completed_checkins, -> { signed_in }, class_name: "CheckinUser"
  
  has_many :users, through: :checkins

  scope :today, -> { where(check_in_by: (Time.now.midnight - 1.day)..Time.now) }
  scope :current, -> { where("check_in_by >= ?", Time.now.yesterday.end_of_day).order( check_in_by: :asc) }
  scope :past, -> { where("check_in_by <= ?", Time.now.yesterday.end_of_day).order( check_in_by: :desc) }
end
