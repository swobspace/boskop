module MyPDF
  module Formatter
    module Concerns
      module LocationConcerns
        extend ActiveSupport::Concern

	included do
	end

       def location_addresses(context, options = {})
         options.symbolize_keys!
         obj   = options.fetch(:object, context.obj)
         title = options.fetch(:title, "Adressen")
         return unless obj.addresses.present?

         context.text title, :style => :bold
         context.move_down 6
         context.indent(MyPDF.indent) do
	   context.table(
	     address_data(obj, address_attributes),
	     cell_style: {
	       padding: 1.5,
	       borders: [],
	     }
	   )
         end
       end

       def location_networks(context, options = {})
         options.symbolize_keys!
         obj   = options.fetch(:object, context.obj)
         title = options.fetch(:title, "Netzwerke")
         return unless obj.networks.present?

         context.text title, :style => :bold
         context.move_down 6
         context.indent(MyPDF.indent) do
	   context.table(
	     network_data(obj, network_attributes),
	     cell_style: {
	       padding: 1.5,
	       borders: [],
	     }
	   )
         end
       end

       def location_merkmale(context, options = {})
         options.symbolize_keys!
         obj   = options.fetch(:object, context.obj)
         title = options.fetch(:title, "Merkmale")
         return unless obj.merkmale.present?

         context.text title, :style => :bold
         context.move_down 6
         context.indent(MyPDF.indent) do
	   context.table(
	     merkmal_data(obj, merkmal_attributes),
	     cell_style: {
	       padding: 1.5,
	       borders: [],
	     }
	   )
	 end
       end

      private

        def address_data(obj, attrs)
          obj.addresses.map do |address|
            attrs.map do |a|
              "#{address.send(a).try(:to_s)}"
            end
          end
        end

        def network_data(obj, attrs)
          obj.networks.map do |network|
            attrs.map do |a|
              "#{network.send(a).try(:to_s)}"
            end
          end
        end

        def merkmal_data(obj, attrs)
          attrs.map do |m|
            [ m.to_s + ":", "#{obj.merkmale.where(merkmalklasse: m).join('; ')}"]
          end
        end

        def address_attributes
          [ :plz, :ort, :streetaddress ]
        end

        def network_attributes
          [ :to_cidr, :description ]
        end

        def merkmal_attributes
          Merkmalklasse.visibles(:network, 'show')
        end

      end
    end
  end
end

