#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

require 'csv'

file = ARGV[0]

unless (File.writable?("#{file}"))
  puts "File #{file} not writable"
  exit 1
end

mknet_verwendung = Merkmalklasse.where(for_object: 'Network', tag: 'verwendung').ids.first
mknet_vlan = Merkmalklasse.where(for_object: 'Network', tag: 'vlan').ids.first
mkloc_group = Merkmalklasse.where(for_object: 'Location', tag: 'standortgruppe').ids.first
mkloc_type = Merkmalklasse.where(for_object: 'Location', tag: 'standorttyp').ids.first

networks =  Network.joins(:location)
            .where(locations: {disabled: false})
            .where.not("netzwerk <<= '172.24.0.0/16'")
            .where.not("netzwerk <<= '192.168.0.0/18'")
            .where.not("netzwerk <<= '192.168.64.0/21'")
            .where.not("netzwerk <<= '192.168.178.0/23'")
            .where.not("netzwerk <<= '10.199.0.0/16'")

CSV.open("#{file}", "wb", :col_sep =>"\t") do |csv|
 csv << [
          # tsystems stuff
          "position", 
          "object_name",
          "object_type",
          "address",
          "netmask",
          "cidr",
          "country",
          "location",
          "purpose",
          "comment",
          # marienhaus stuff
          "LID",
          "Einrichtung",
          "Verwendung",
          "VLAN",
          "lokales Netz",
          "Gateway",
          "Standorttyp",
          "Standortgruppe",
        ]
   networks.each do |net|
   cidr = net.netzwerk.to_cidr_mask.to_i
   mask = (('1'*cidr)+('0'*(32-cidr))).scan(/.{8}/m).map{|e|e.to_i(2)}.join('.')
   vlan = net.merkmale.where(merkmalklasse_id: mknet_vlan).first
   name = "NET_#{net.location.lid}_"
   postfix = net.netzwerk.to_s.gsub(/\./, "_").gsub(/_0\z/, "")
   appendix = "-#{net.netzwerk.to_cidr_mask}"
   csv << [
          # tsystems stuff
          "", 
          name + postfix + appendix,
          "Netz",
          net.netzwerk.to_s,
          mask,
          cidr,
          "Germany",
          net.location.ort,
          net.merkmale.where(merkmalklasse_id: mknet_verwendung).first,
          net.description,
          # marienhaus stuff
          net.location.lid,
          net.location.to_s,
          net.merkmale.where(merkmalklasse_id: mknet_verwendung).first,
          vlan,
          "",
          "",
          net.location.merkmale.where(merkmalklasse_id: mkloc_type).first,
          net.location.merkmale.where(merkmalklasse_id: mkloc_group).first,
        ]
  end

end
