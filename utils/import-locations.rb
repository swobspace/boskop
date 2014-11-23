#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

require 'csv'

file = ARGV[0]
testrun = ARGV[1]

unless (File.readable?("#{file}"))
  puts "File #{file} not readable"
  exit 1
end

address_attributes = Address.attribute_names.reject! {|k,v| ['id', 'created_at', 'updated_at'].include?(k) }
location_attributes = Location.attribute_names.reject! {|k,v| ['id', 'created_at', 'updated_at'].include?(k) }

CSV.foreach("#{file}", :col_sep =>";", :headers => true) do |row|
  hash = row.to_hash
  use  = hash.extract!('use')['use']
  next if use.blank?
  address_data  = hash.extract!(*address_attributes)
  location_data = hash.extract!(*location_attributes)
   
  puts location_data
  puts address_data
  puts hash

end
