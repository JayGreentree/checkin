class CheckinUsersController < ApplicationController

  def index
    @checkin = CheckinUser.new( checkin_session: CheckinSession.find( params[:id] ) )

    render action: :checkin
  end


  def checkin
    @checkin = CheckinUser.
               find_or_initialize_by( rapid_checkin_params )
    if @checkin.invalid?
      @checkin.checkin_status = :error
    elsif @checkin.new_record? && @checkin.valid?
      @checkin.checkin_status = :error
      @checkin.errors.add(:base, "#{@checkin.user.name} is not on this checkin list")
    else
      # TODO: Warn about an already checked-in user & prompt to re-checkin
      #if @checkin.checked_in_at.nil?
        @checkin.checked_in_at = Time.now
        @checkin.attendant = current_user
        
        if @checkin.save
          @checkin.checkin_status = :success
        else
          @checkin.checkin_status = :error
          @checkin.errors.add(:base, "Error: Checkin failed")
        end
      #else
      #  @checkin.checkin_status = :warning  
      #end
    end

    respond_to do |format|
      if @checkin.checkin_status == :error
        format.html { flash[:rapid_checkin] = "#{@checkin.errors.full_messages.join("; ")}" }
        #format.js {}
        #format.json { render json: @user, status: :created, location: @user }
      elsif @checkin.checkin_status == :success
        format.html { flash[:rapid_checkin] = "#{@checkin.user.name} successfully checked in" }
        #format.js {}
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
      
  end


  private
  def rapid_checkin_params
    params.require(:rapid_checkin).permit(:user_search, :checkin_session_id)
  end
  
end
