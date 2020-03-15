class String
  def integer?
    return true if self =~ /\A\d+\Z/
  end

  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
end
