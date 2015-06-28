class DashboardController < ApplicationController
  skip_before_filter :require_authentication
  
  def index
  end
end
