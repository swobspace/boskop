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

merkmalklassen = Merkmalklasse.where(for_object: 'Network').map {|mk| [mk.name, mk.id]}
merkmalklassen = Hash[*merkmalklassen.flatten]

network_attributes = Network.attribute_names.reject! {|k,v| ['id', 'created_at', 'updated_at'].include?(k) }

CSV.foreach("#{file}", :col_sep =>"\t", :headers => true) do |row|
  hash = row.to_hash
  use  = hash.extract!('use')['use']
  next if use.blank?
  lid  = hash.extract!('LID')['LID']
  network_data = hash.extract!(*network_attributes)
  merkmal_data = hash.reject {|k,v| !merkmalklassen.keys.include?(k)}
  nw = network_data.extract!('netzwerk')['netzwerk'].to_s.gsub(/\s*/, '')
  puts nw
  name = lid + "-" + nw.match(/\A\d+\.\d+\.(\d+)\.\d+/)[1]

  location = Location.where(lid: lid).first

  network_data.merge!(name: name)
  network_data_query = { location_id: location.try(:id), netzwerk: nw }

  puts "---"
  puts "Network: #{network_data_query} + #{network_data}"
  puts "Location: #{lid} / #{location}"
  puts "Merkmale: #{merkmal_data}"

  network = Network.create_with(network_data).find_or_initialize_by(network_data_query)
  if network.new_record?
    merkmal_data.each do |k,v|
      network.merkmale.build(
        merkmalklasse_id: merkmalklassen[k],
        value: v
      )
    end
    if network.save
      puts "... saved"
    else
      puts "### ERROR, #{network.name} not saved"
      puts "### #{network.errors.inspect}"
    end
  else 
    puts "- RECORD always exists"
  end

end
