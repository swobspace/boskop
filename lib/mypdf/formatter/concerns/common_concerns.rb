module MyPDF
  module Formatter
    module Concerns
      module CommonConcerns
	extend ActiveSupport::Concern

	included do
	end

        # <tt>location_header(
        #       context, 
        #       location: location, 
        #       position: [x, y],
        # )</tt>
        # set a location header with location id tag and location address
        def location_header(context, options = {})
          location = options.fetch(:location)
          position = options.fetch(:position)
          height        = MyPDF.header_height
          lid_width     = 90
          address_width = MyPDF.header_width - lid_width
          # location id box
          context.bounding_box [0,position], width: lid_width, height: height do
            context.pad(10) do
              context.span(lid_width - 20, align: :center) do
                context.text location.lid, align: :center, size: 20, style: :bold
              end
            end
	    context.stroke_color MyPDF.header_color
	    context.stroke_bounds
          end
          # name and address box
          context.bounding_box [lid_width, position], width:  address_width, height: height do
            context.pad(10) do
              context.text location.name, size: 14, style: :bold
              context.move_down 6
              if addr = location.addresses.first
                context.text "#{addr.plz} #{addr.ort}, #{addr.streetaddress}"
                context.move_down 6
              end
            end
	    context.stroke_color MyPDF.header_color
	    context.stroke_bounds
          end
        end

	def subject(context, options = {})
          options.symbolize_keys!
          subj = options.fetch(:subject, context.title)
          align = options.fetch(:align, :center)
          indent = (align == :center) ? 0 : MyPDF.indent
	  context.bounding_box [0, context.cursor], :width => 481 do
	    context.pad(10) do
	      context.span(450, position: align) do
                context.indent(indent) do
		  context.text subj, align: align, :style => :bold
                end
	      end
	    end
	    context.stroke_color MyPDF.header_color
	    context.stroke_bounds
	  end
	  context.move_down 12
        end

	def section(context, options = {})
          options.symbolize_keys!
          obj      = options.fetch(:object, context.obj)
          title    = options.fetch(:title)
          attr     = options.fetch(:attribute)
          optional = options.fetch(:optional, false)
          blank    = options.fetch(:blank, "")
          value    = (obj.send(attr).blank?) ? nil : obj.send(attr)
          min_free = options.fetch(:min_free, nil)
          skip     = options.fetch(:or_skip, 0)

	  if optional
	    return "" if value.nil?
	  end
          if min_free
            check_remaining_space(context, min_free: min_free, or_skip: skip)
          end
	  context.text title, :style => :bold
	  context.move_down 6
	  msg = value || blank
	  context.indent(MyPDF.indent) do
	    context.text msg.to_prawn, :inline_format => true
	  end
	  context.move_down 12
	end

        def anlagen(context, options = {})
          options.symbolize_keys!
          obj   = options.fetch(:object, context.obj)
          title = options.fetch(:title, "Anlagen:")
          optional = options.fetch(:optional, false)
          if optional && obj.anlagen.empty?
            return ""
          end
	  context.text title, :style => :bold
	  context.move_down 6
	  context.indent(MyPDF.indent) do
	    if obj.anlagen.size > 0
	      obj.anlagen.each do |anlage|
		unless anlage.description.blank?
		  context.text anlage.description
		else
		  context.text anlage.datei_identifier
		end
	      end
	    else
	      context.text "Keine"
	    end
	  end
	  context.move_down 12
	end

        def check_remaining_space(context, options = {})
          options.symbolize_keys!
          min_free      = options.fetch(:min_free)
          skip          = options.fetch(:or_skip, 0)
          if context.cursor < (min_free + skip)
           context.start_new_page
          else
            context.move_down skip
          end
        end

        def indent_text(context, options = {})
          options.symbolize_keys!
          obj  = options.fetch(:object, context.obj)
          text = options.fetch(:text)
	  context.indent(MyPDF.indent) do
	    context.text text.to_prawn, :inline_format => true
	  end
	  context.move_down 12
        end
      end
    end
  end
end

