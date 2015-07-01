class CheckinUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :checkin_session

  attr_accessor :user_search, :checkin_status

  validates_presence_of :user, message: "could not be found"
  validates_presence_of :checkin_session, message: "could not be found"

  # Translate user_search into an actual andrew user
  def self.find_or_initialize_by params
    params[:user] ||= User.find_andrew_user(params[:user_search])

    # remove non-db-column parameters from hash to prevent error
    super(params.reject{|k,v| k=="user_search"})
  end
end
