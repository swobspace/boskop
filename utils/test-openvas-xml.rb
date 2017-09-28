#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

file = ARGV[0] || "/home/wob/Projects/boskop/spec/fixtures/files/openvas-wobnet-anon.xml"

unless (File.readable?("#{file}"))
  puts "File #{file} not readable"
  exit 1
end

doc = File.open(file) { |f| Nokogiri::XML(f) }

puts doc.xpath("//report/omp/version").text
puts doc.xpath("//report/scan_start").text
puts doc.at("report_format/name").text
doc.xpath("//report/results/result").each do |result|
  puts "#{result.at('host').text}"
  puts "  " +  result.at('threat').text
  puts "  " +  result.at('severity').text
  puts result.at("nvt").attr('oid')
  puts "  " +  result.at('nvt/name').text
  puts "  " +  result.at('nvt/family').text
  puts "  " +  result.at('nvt/cvss_base').text
  puts "  " +  result.at('nvt/cve').text
  puts "  " +  result.at('nvt/bid').text
  puts "  " +  result.at('nvt/xref').text
  # puts "  " +  result.at('nvt/tags').text
  puts "  " +  result.at('nvt/cert').text
end
doc.xpath("//report/host").each do |host|
  closed_cves = host.xpath('./detail/name[contains(text(), "Closed CVE")]')
  closed_cves.each do |cve|
    node = cve.parent
    puts "  closed: " +  node.at('value').text
    puts "  closed: " +  node.at('source/type').text
    puts "  closed: " +  node.at('source/name').text
  end
end

