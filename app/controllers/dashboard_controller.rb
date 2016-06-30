class DashboardController < ApplicationController
  skip_before_action :require_authentication
  
  def index

    if current_user && current_user.staff?
      @upcoming_checkins = current_user.checkin_sessions.current
      @past_checkins = current_user.checkin_sessions.past
    end
  end
end
