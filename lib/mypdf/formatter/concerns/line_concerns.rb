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

         context.text title, :style => :bold
         context.move_down 6
         context.indent(MyPDF.indent) do
           context.table(
             line_basics_data(obj, line_basics_attributes),
             cell_style: {
               padding: 1.5,
               borders: [],
             }
           )
         end
       end

      private

        def line_basics_data(obj, attrs)
          attrs.map do |a| 
            [ I18n.t('attributes.' + a.to_s) + ":", "#{obj.send(a)}"]
          end
        end

        def line_basics_attributes
          [:provider_id]
        end

      end
    end
  end
end

