class CheckinSessionsController < ApplicationController
  def index
    redirect_to root_url
  end

  def show
    redirect_to rapid_checkin_url(params[:id])
  end

  def update
  end

  def new
    redirect_to root_url
  end
  
  def create
  end

  def destroy
  end
end
