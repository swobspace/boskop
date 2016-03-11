module MyPDF
  module Formatter
    class LocationFormatter
      include MyPDF::Formatter::Concerns::CommonConcerns
      include MyPDF::Formatter::Concerns::LocationConcerns

      def render_output(context, obj, params = {})
        subject(context, subject: "Stammblatt")
        section(context, object: obj, 
                title: I18n.t('attributes.description'),
                attribute: :description)
        location_merkmale(context, params)
        location_addresses(context, params)
        location_networks(context, params)
      end
    end
  end
end
