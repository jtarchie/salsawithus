class Time
  def same_day?(time)
    return self.same_year?(time) && self.same_month?(time) && self.day == time.day
  end
  
  def same_month?(time)
    return self.same_year?(time) && self.month == time.month
  end
  
  def same_year?(time)
    return self.year == time.year
  end
end