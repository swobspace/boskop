#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-
# usage: get_nessus_scan_list
# retrieves a list of current scans
# --

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'
require 'net/http'

puts Rails.application.secrets.nessus_access_key
puts Boskop.nessus_url

uri = URI(Boskop.nessus_url + '/scans')

http = Net::HTTP.new(uri.host, uri.port)
http.ca_file = Boskop.nessus_ca_file
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

req = Net::HTTP::Get.new(uri)

req['X-ApiKeys'] = "accessKey=#{Rails.application.secrets.nessus_access_key}; " +
                   "secretKey=#{Rails.application.secrets.nessus_secret_key};"

response = http.request(req)
parsed = JSON.parse(response.body)
parsed['scans'].each do |scan|
  lastmod = Time.at(scan['last_modification_date'])
  puts "#{scan['name']}\t#{scan['uuid']}\t#{lastmod}\t#{scan['status']}"
end

