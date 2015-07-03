module CheckinUsersHelper

  def feedback_classes( options = {} )
    classes = {
      "input_group" => %w{input-group},
      "glyphicon" => %w{glyphicon form-control-feedback},
      "result_explanation" => %w{result-explanation text-left}
    }
  
    #TODO add warning states
    if options[:checkin].checkin_status == :error
      classes["input_group"].concat %w{has-feedback has-error}
      classes["glyphicon"].concat %w{glyphicon-remove}
      classes["result_explanation"].concat %w{bg-danger text-danger}
    elsif options[:checkin].checkin_status == :success
      classes["input_group"].concat %w{has-feedback has-success}
      classes["glyphicon"].concat %w{glyphicon-ok}
      classes["result_explanation"].concat %w{bg-success text-success}
    #elsif options[:checkin].checkin_status == :warning
    end

    classes[options[:context]].join(" ")
  end

  
  
  def checkin_percent( options = {} )
    ((options[:session].send(options[:scope]).size*100 /
      options[:session].checkins.size.to_f )).to_s
  rescue NoMethodError,
         ZeroDivisionError
    "0"
  end

  def missing_percent session
    checkin_percent( session: session,
                     scope: :missing_checkins )
  end

  def on_time_percent session
    checkin_percent( session: session,
                     scope: :on_time_checkins )
  end

  def late_percent session
    checkin_percent( session: session,
                     scope: :late_checkins )
  end


  def checkin_table_row_classes( checkin )
    if checkin.missing_after_curfew?
      "danger"
    end

  end

  def filter_checkins( session, scope )
    if ["missing_checkins","completed_checkins","checkins"].include? scope
      session.send(scope)
    else
      session.checkins
    end
  end
end
