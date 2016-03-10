module MyPDF
  module Formatter
    module Concerns
      module LineConcerns
        extend ActiveSupport::Concern

	included do
	end

       def line_basics(context, options = {})
         options.symbolize_keys!
         obj   = options.fetch(:object, context.obj)
         title = options.fetch(:title, "Parameter")

	 context.table(
	   location_data(obj, location_attributes) +
	   line_basics_data(obj, line_basics_attributes) +
	   contract_data(obj),
	   cell_style: {
	     padding: 1.5,
	     borders: [],
	   }
	 )
       end

      private

        def location_data(obj, attrs)
          attrs.map do |a|
            [ I18n.t('attributes.' + a.to_s) + ":", "#{obj.send(a).try(:to_string)}"]
          end
        end

        def line_basics_data(obj, attrs)
          attrs.map do |a|
            [ I18n.t('attributes.' + a.to_s) + ":", "#{obj.send(a)}"]
          end
        end

        def location_attributes
          [:location_a, :location_b]
        end

        def line_basics_attributes
          [
           :description, :notes, :provider_id, :access_type, :bandwith,
           :line_state, :framework_contract,
          ]
        end

        def contract_data(obj)
         [
          [ I18n.t('attributes.contract_start') + ":", "#{obj.contract_start}"],
          [ I18n.t('attributes.contract_end') + ":", "#{obj.contract_end}"], 
          [ I18n.t('attributes.contract_period') + ":", "#{obj.contract_period}"], 
          [ I18n.t('attributes.period_of_notice') + ":", 
            "#{obj.period_of_notice} #{obj.period_of_notice_unit}"], 
          [ I18n.t('attributes.renewal_period') + ":", 
            "#{obj.renewal_period} #{obj.renewal_unit}"]
         ]
        end

      end
    end
  end
end

