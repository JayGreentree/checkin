class CheckinSessionsController < ApplicationController
  def index
  end

  def show
    redirect_to rapid_checkin_url(params[:id])
  end

  def update
  end

  def new
  end
  
  def create
  end

  def destroy
  end
end
