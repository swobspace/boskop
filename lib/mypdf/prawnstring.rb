class String
  def to_prawn
    self.
      gsub(/\r\n?/, "\n").
      gsub(/(.+?)\n(?!\n)([^\n*-]+?)/, '\1 \2').
      gsub(/\*\*(.*?)\*\*/, '<b>\1</b>')
  end
end

