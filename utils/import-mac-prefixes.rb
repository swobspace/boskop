#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

require 'csv'

file = 'nmap-mac-prefixes.csv'

unless (File.readable?("#{file}"))
  puts "File #{file} not readable"
  exit 1
end

CSV.foreach("#{file}", :col_sep =>"\t", :headers => false) do |row|
  MacPrefix.create_with(vendor: row[1]).find_or_create_by!(oui: row[0])
end
