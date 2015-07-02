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

    t.friday? || t.saturday? ? t+1.hour : t
  end
end
