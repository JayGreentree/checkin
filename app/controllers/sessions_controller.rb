class SessionsController < ApplicationController
  skip_before_action :require_authentication
  before_action :require_andrew_realm, :only => :create

  ###
  # Login the user
  def create
    login( http_remote_user )

    if current_user && params[:return_url]
      redirect_to params[:return_url]
    elsif current_user
      redirect_to root_url
    end
  end

  ###
  # Logout and then redirect user to the main page
  def destroy
    logout

    flash[:success] = "Local logout completed successfully. You MUST close your browser to complete the logout process."
    redirect_to "/Shibboleth.sso/Logout?return=" + root_url
  end


  protected

  ###
  # Redirect unless the user is from andrew.cmu.edu
  def require_andrew_realm
    unless http_remote_user_realm == 'andrew.cmu.edu'
            flash[:error] = "You are authenticated to the #{http_remote_user_realm}
                       realm. Please use shibboleth to login as an @andrew.cmu.edu
                       user"
            redirect_to root_url
    end
  end
end
