require 'mypdf/formatter'
module MyPDF
  class Line < MyPDF::Template
    include MyPDF::Formatter::Concerns::CommonConcerns

    def body
      @formatter = MyPDF::Formatter::LineFormatter.new
      @formatter.render_output(self, @obj)
    end

    def myheader
      location_header(
        self, location: @obj.location_a, position: myheaderheight)
    end
   
    def title
      "#{@obj.name}"
    end

    def footer_tag
      "Line ##{@obj.id.to_param}"
    end

    def footer_stamp
      date = @options.fetch(:date, Date.today)
      "Stand: #{date}"
    end

    protected

    def set_watermark?
      false
    end

  end
end
