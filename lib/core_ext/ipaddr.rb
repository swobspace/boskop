class IPAddr

  def to_cidr_s
    if @addr
      "#{to_s}/#{to_cidr_mask}"
    else
      nil
    end
  end

  def to_cidr_mask
    if @addr
      mask = @mask_addr.to_s(2).count('1').to_s
    else
      nil
    end
  end

end
