#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment.rb'

n = GELF::Notifier.new(ENV['GRAYLOG_SERVER'], 12201)
n.notify!(
  short_message: "linux01 / unsupported OS",
  full_message: "Boskop: should be al very long full message",
  _host: "linux01",
  _location: "BER",
  _ip_address: "192.0.2.71",
  _host_kategorie: "Windows/Fileserver",
  _operating_system: "Windows Server 2008 R2",
  _vulnerability: "Unsupported OS",
  _lastseen: "heute",
  _threat: "Critical",
  _severity: "10.0"
)
