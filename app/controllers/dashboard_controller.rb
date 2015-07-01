class DashboardController < ApplicationController
  skip_before_filter :require_authentication
  
  def index

    if current_user && current_user.staff?
      @upcoming_checkins = current_user.checkin_sessions.current
    end
  end
end
