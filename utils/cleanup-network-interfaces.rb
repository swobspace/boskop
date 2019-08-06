#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

NetworkInterface.group(:ip, :mac, :host_id).having("count(*) > 1").count.each do |ih,count|
  iface = NetworkInterface
          .where(ip: ih[0].to_s, mac: ih[1], host_id: ih[2])
          .order("lastseen desc").offset(1)
  iface.destroy_all
end
