#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'development'
require File.dirname(__FILE__) + '/../../config/environment.rb'

require 'mypdf'

# line = Line.find 105
# pdf = MyPDF::Line.new(line)
 
loc = Location.find 105
pdf = MyPDF::Location.new(loc)

pdf.render_output
pdf.render_file("out.pdf")

