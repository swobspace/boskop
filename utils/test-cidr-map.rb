#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-
# usage: test_cidr_map network mask
# generates all subnets within network with mask
# and searches for available networks
# --

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

require 'cidr_addresses'

network = ARGV[0]
mask    = ARGV[1].to_i


if mask == 0 # nil.to_i == 0
  puts "usage: #{__FILE__} network mask"
  puts "i.e. #{__FILE__} 192.168.0.0/16 24"
  exit 1
end

parent = IPAddr.new(network)
subnet = parent.mask(mask)

puts "parent: #{parent.inspect}"
puts "start : #{subnet}"

bitstep = 2**(32 - mask)

while parent.include?(subnet) do
  print "subnet: #{subnet.to_cidr_s}"
  nets = Network.where.contains_or_equals(netzwerk: subnet).all
  nets += Network.where.contained_within_or_equals(netzwerk: subnet).all
  nets = nets.map{|x| "#{x.netzwerk.to_cidr_s} / #{x.location.try(:lid)}"}
  puts " >> #{nets.join(', ')}"

  nextsubnet = subnet.to_i + bitstep
  subnet = IPAddr.new(nextsubnet, Socket::AF_INET).mask(mask)
end

