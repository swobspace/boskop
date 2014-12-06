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

CSV.foreach("#{file}", :col_sep =>";", :headers => true) do |row|
  hash = row.to_hash
  use  = hash.extract!('use')['use']
  next if use.blank?
  lid  = hash.extract!('LID')['LID']
  network_data = hash.extract!(*network_attributes)
  merkmal_data = hash.reject {|k,v| !merkmalklassen.keys.include?(k)}
  name = lid + "-" + network_data['netzwerk'].to_s.match(/\A\d+\.\d+\.(\d+)\.\d+/)[1]

  location = Location.joins(merkmale: :merkmalklasse).
               where(["merkmale.value = ? AND merkmalklassen.name = 'StandortID'", lid]).first
  network_data.merge!(name: name, location_id: location.try(:id))

  puts "---"
  puts "Network: #{network_data}"
  puts "Location: #{lid} / #{location}"
  puts "Merkmale: #{merkmal_data}"

  network = Network.find_or_initialize_by(network_data)
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
