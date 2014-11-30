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

merkmalklassen = Merkmalklasse.where(for_object: 'OrgUnit').map {|mk| [mk.name, mk.id]}
merkmalklassen = Hash[*merkmalklassen.flatten]

address_attributes = Address.attribute_names.reject! {|k,v| ['id', 'created_at', 'updated_at'].include?(k) }
orgunit_attributes = OrgUnit.attribute_names.reject! {|k,v| ['id', 'created_at', 'updated_at'].include?(k) }

CSV.foreach("#{file}", :col_sep =>";", :headers => true) do |row|
  hash = row.to_hash
  use  = hash.extract!('use')['use']
  next if use.blank?
  address_data  = hash.extract!(*address_attributes)
  orgunit_data = hash.extract!(*orgunit_attributes)
  merkmal_data = hash.reject {|k,v| !merkmalklassen.keys.include?(k)}

  puts "---"
  puts "OrgUnit: #{orgunit_data}"
  puts "Adresse : #{address_data}"
  puts "Merkmale: #{merkmal_data}"

  orgunit = OrgUnit.find_or_initialize_by(orgunit_data)
  if orgunit.new_record?
    orgunit.addresses.build(address_data)
    merkmal_data.each do |k,v|
      orgunit.merkmale.build(
        merkmalklasse_id: merkmalklassen[k],
        value: v
      )
    end
    if orgunit.save
      puts "... saved"
    else
      puts "### ERROR, #{orgunit.name} not saved"
      puts "### #{orgunit.errors.inspect}"
    end
  else 
    puts "- RECORD always exists"
  end

  # break

end
