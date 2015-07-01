class CheckinUsersController < ApplicationController

  def index
    @checkin = CheckinUser.new( checkin_session: CheckinSession.find( params[:id] ) )

    render action: :checkin
  end


  def checkin
    @checkin = CheckinUser.
               find_or_initialize_by( rapid_checkin_params )
    if @checkin.new_record? && @checkin.valid?
      @checkin.errors.add(:base, "#{@checkin.user.name} is not on this checkin list")
    else
      @checkin.checked_in_at = Time.now
      @checkin.save!
    end
  end


  private
  def rapid_checkin_params
    params.require(:rapid_checkin).permit(:user_search, :checkin_session_id)
  end
  
end
