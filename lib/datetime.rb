class Date
  def to_checkin_datetime(type)
    t = self.to_time(:local)
    
    if type == :building
      t += 22.5.hours
    elsif type == :floor
      t += 23.hours
    else
      raise 'Checkin type not found'
    end

    t += 1.hour if t.friday? || t.saturday?
    t = (t - 1.day).end_of_day if t == t.at_midnight
    t
  end
end
