class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_filter :require_authentication

  private
  def require_authentication
    unless authenticated?
      redirect_to login_url(:return_url => request.env["REQUEST_URI"])
    end
  end
end
