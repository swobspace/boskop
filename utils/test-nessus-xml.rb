#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'


if ARGV[0].blank?
  puts "usage: #{__FILE__} <nessus.xml> [<ip>]"
  exit 1
else
  file = ARGV[0]
  ip   = ARGV[1]
end

unless (File.readable?("#{file}"))
  puts "File #{file} not readable"
  exit 1
end

xml = Boskop::Nessus::XML.new(file: file)

if xml.valid?
  puts "#{file} is a valid nessus xml file"
else
  raise RuntimeError, "ERROR: #{file} is not a valid nessus xml file"
end

xml.each do |report_host|
  if ip
    next  unless ip == report_host.ip
  end
  puts report_host.attributes.inspect
  # puts report_host.report_item(plugin_id: 111688).plugin_output
  report_host.each do |item|
    puts item.attributes.inspect
  end
end

