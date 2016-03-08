require 'mypdf/prawnstring'
require 'mypdf/formatter'
require 'prawn/measurement_extensions'
require 'prawn/table'

module MyPDF
  autoload :Template, 'mypdf/template'
  autoload :Line, 'mypdf/line'

  def self.setup
    yield self
  end

  # font size and colors 
  mattr_accessor :header_color, :footer_color, :font_size
  @@header_color = '9A999E'
  @@footer_color = '9A999E'
  @@font_size    = 11

  # page size in pdf pts
  # PDF-Size: A4: 595x842
  # Printable with margin 20.mm (57pt*2): 481x728
  mattr_accessor :page_width, :page_height
  @@page_width  = 481
  @@page_height = 728

  # misc layout settings
  mattr_accessor :indent, :header_height, :header_width
  @@indent = 20
  @@header_height = 85 # 30 mm
  @@header_width  = 390

end
