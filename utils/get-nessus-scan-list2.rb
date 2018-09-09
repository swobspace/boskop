#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-
# usage: get_nessus_scan_list
# retrieves a list of current scans
# using tenable-ruby
# --

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'tenable-ruby'

nessus = TenableRuby::Client.new(
           credentials: { 
             access_key: Rails.application.secrets.nessus_access_key,
             secret_key: Rails.application.secrets.nessus_secret_key
           },
           url: Boskop.nessus_url
         )

n = nessus.authenticate

list = nessus.scan_list
puts list['timestamp']

list['scans'].each do |scan|
  lastmod = Time.at(scan['last_modification_date'])
  puts "#{scan['id']}\t#{scan['name']}\t#{scan['uuid']}\t#{lastmod}\t#{scan['status']}"
end

# nessus.report_download_file(113, 'nessus', 'report.nessus')
