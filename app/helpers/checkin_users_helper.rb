module CheckinUsersHelper

  def input_group_classes(user_checkin)
    if user_checkin.errors.any?
      "input-group has-feedback has-error"
    else
      "input-group"
    end
  end

end
