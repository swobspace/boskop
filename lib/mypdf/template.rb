module MyPDF
  class Template < Prawn::Document
    attr_reader :obj, :options, :title

    def initialize(obj, options = {})
      @obj     = obj
      @options = sanitize_options(options)
      super(page_options)
    end

    def render_output
      font_families.update(
        "DejaVuSans" => {
          :normal => "/usr/share/fonts/dejavu/DejaVuSans.ttf",
          :italic => "/usr/share/fonts/dejavu/DejaVuSans-Italic.ttf",
          :bold => "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf",
          :bold_italic =>"/usr/share/fonts/dejavu/DejaVuSans-BoldItalic.ttf",
        }
      )
      font "DejaVuSans"
      font_size MyPDF.font_size
      watermark
      logo
      header
      body
      page_numbers
      footer
      pagetwo_header
    end

    def title
      raise RuntimeError, "Calling abstract method title is not allowed"
    end

    # --- 
    protected
    # ---
    def watermark
      return unless set_watermark?
      watermark_text = @options.fetch(:watermark, "Entwurf")
      create_stamp("watermark") do
	rotate(60, :origin => [0, 0], :overflow => :expand ) do
	  fill_color "000000"
	  font_size(128) do
            transparent(0.20) do
	      draw_text watermark_text, :at => [35, 0]
            end
	  end
	  fill_color "000000"
	end
      end
      repeat :all do
        stamp_at "watermark", [150,150]
      end
    end

    def set_watermark?
      raise RuntimeError, "Calling abstract method set_watermark? is not allowed"
    end

    def logo
      logo   = Boskop.logo_image
      width  = (Boskop.logo_width).mm
      height = MyPDF.header_height
      bounding_box [MyPDF.header_width, 750], width: width, height: height do
        image File.join(Rails.root, "public", "images", logo),
          fit: [width, height], position: :right
      end
    end

    def header
      bounding_box [0,750], width: MyPDF.header_width, height: myheaderheight do
        myheader 
      end
      move_down 12
    end
   
    def myheaderheight
      MyPDF.header_height
    end

    def myheader
      raise RuntimeError, "Calling abstract method myheader is not allowed"
    end

    def body
      raise RuntimeError, "Calling abstract method body is not allowed"
    end

    def page_numbers
      number_pages "Seite <page> von <total>", {
        :at => [MyPDF.page_width - 150, (footer_height1 + 9)],
        :width => 150,
        :align => :right,
        :start_count_at => 1,
        :color => MyPDF.footer_color }
    end

    def footer
      repeat :all do
        fill_color MyPDF.footer_color
        draw_text "#{footer_tag}",   :at => [  0, footer_height1], :width => 100
        draw_text "#{footer_stamp}", :at => [160, footer_height1], :width => 50
        if footer_line2
          draw_text footer_line2, at: [0,footer_height2]
        end
      end
    end

    def footer_line2
      nil
    end

    def footer_height1
      -16
    end
    def footer_height2
      -30
    end

    def pagetwo_header
      fill_color MyPDF.footer_color
      repeat(lambda { |pg| pg > 1 }) do
        draw_text "#{title}", :at => [0,750]
      end
    end

    def footer_tag
      raise RuntimeError, "Calling abstract method footer_tag is not allowed"
    end

    def footer_stamp
      "Print: #{DateTime.now.strftime('%Y-%m-%d %H:%M')}"
    end

    def type(obj)
      MyPDF::Formatter::Concerns::CommonConcerns.type(obj)
    end

    # ---
    private
    # ---
    def sanitize_options(opts)
      opts.symbolize_keys
    end

    def page_options
      default_page_options.merge(@options.fetch(:pdf_page_options, {}))
    end

    def default_page_options
      { page_size: "A4", margin: 20.mm }
    end
  end
end
