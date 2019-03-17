#!/usr/bin/env ruby

require 'json'
require 'csv'

pwd = File.dirname(__FILE__)
inventory_path="/omd/sites/ccnetze/var/check_mk/inventory/"

class Hardware
  attr_reader :hardware, :unparseable, :file

  def initialize(json)
    @unparseable = false
    begin
      @json = JSON.parse(json)
    rescue
      @json = nil
      @unparseable = true
    end
    @hardware = hardware
    @memory   = memory
    @system   = system
  end

  def hardware
    return nil if @json.nil?
    @json['hardware']
  end

  def memory
    return nil if hardware.nil?
    hardware['memory']
  end

  def bios
    return nil if hardware.nil?
    hardware['bios']
  end

  def system
    return nil if hardware.nil?
    hardware['system']
  end

  def total_usable_ram
    return nil if memory.nil?
    sprintf "%.2f", (memory['total_ram_usable']).to_f / 1024**3
  end

  def bios_date
    return nil if bios.nil?
    begin
      Time.at(bios['date']).strftime("%Y-%m-%d")
    rescue
      nil
    end
  end

  def bios_version
    return nil if bios.nil?
    bios['version']
  end

  def product
    return nil if system.nil?
    system['product']
  end

  def serial
    return nil if system.nil?
    system['serial']
  end

  def manufacturer
    return nil if system.nil?
    system['manufacturer']
  end

end


CSV.open("/omd/sites/ccnetze/hspfire-inventory.csv", "wb", col_sep: "\t") do |csv|
  csv << [ "hostname", 
           "error",
           "usable_memory", 
           "bios_date",
           "bios_version",
           "manufacturer", 
           "product", 
           "serial",
         ]

  cmd = File.expand_path(File.join(pwd, 'inventory2json.py'))
  Dir.chdir(inventory_path) do
    Dir["*"].reject{|i| i =~ /.gz/}.sort.each do |f|
      puts inventory_path + f
      json = `#{cmd} #{f}`
      hw = Hardware.new(json)
      csv << [ 
               f.to_s, 
               ("X" if hw.unparseable),
               hw.total_usable_ram,
               hw.bios_date,
               hw.bios_version,
               hw.manufacturer,
               hw.product,
               hw.serial,
             ]
    end
  end
end
