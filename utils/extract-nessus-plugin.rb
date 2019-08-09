#!/usr/bin/env ruby
require 'optparse'
require 'ostruct'

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'


options = OpenStruct.new
options.plugin_ids = []
options.hosts = []

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options] <xmlfile> [... <xmlfile>]"
  opts.on("-p", "--plugin-id <id>", "nessus plugin id to extract") do |pid|
    options.plugin_ids += pid.split(/,/)
  end
  opts.on("-H", "--host <ip>", "extract only data from host") do |host|
    options.hosts << host
  end
  opts.on("-h", "--help", "Prints this help") do
    puts opts
  end

end.parse!

if ARGV.empty?
  puts "Usage: #{__FILE__} [options] <xmlfile> [... <xmlfile>]"
  exit 1
end

puts ""

ARGV.each do |file|
  unless (File.readable?("#{file}"))
    puts "ERROR: File #{file} not readable, skipping ..."
    next
  end

  xml = Boskop::Nessus::XML.new(file: file)
  unless xml.valid?
    puts "ERROR: #{file} is not a valid nessus xml file, skipping"
    next
  end

  CSV.open("plugin_report.csv", "wb") do |csv|
    csv << ["name", "ip"] + options.plugin_ids
    xml.each do |report_host|
      if options.hosts.any?
	next unless options.hosts.include?(report_host.ip)
      end
      entry = ["#{report_host.name}", "#{report_host.ip}"]
      puts entry.join("; ")
      options.plugin_ids.each do |pid|
	item = report_host.report_item(plugin_id: pid)
        unless item.blank?
          entry << item.plugin_output&.strip
        end
      end
      csv << entry
    end
  end
end
