class CheckinUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :checkin_session

  attr_accessor :user_search, :checkin_status

  validates_presence_of :user, message: "could not be found"
  validates_presence_of :checkin_session, message: "could not be found"
  validates :user, uniqueness: { scope: :checkin_session }

  scope :missing, -> { where( checked_in_at: nil ) }
  scope :signed_in, -> { where.not( checked_in_at: nil ) }
  scope :on_time, -> (on_time_time) { where( "checked_in_at <= ?", on_time_time ) }
  scope :late, -> (on_time_time) { where( "checked_in_at > ?", on_time_time ) }

  # Translate user_search into an actual andrew user
  def self.find_or_initialize_by params
    params[:user] ||= User.find_andrew_user(params[:user_search])

    # remove non-db-column parameters from hash to prevent error
    super(params.reject{|k,v| k=="user_search"})
  end

  def late?
    self.checked_in_at.nil? ? false : self.checked_in_at > self.checkin_session.check_in_by
  end

end
