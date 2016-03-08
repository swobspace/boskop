module MyPDF
  module Formatter
    class LineFormatter
      include MyPDF::Formatter::Concerns::CommonConcerns
      include MyPDF::Formatter::Concerns::LineConcerns

      def render_output(context, obj, params = {})
        subject(context, subject: "#{obj.name}")
        line_basics(context, params)
      end
    end
  end
end
