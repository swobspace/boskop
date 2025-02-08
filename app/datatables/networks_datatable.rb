class NetworksDatatable < ApplicationDatatable
  delegate :edit_network_path, to: :@view
  delegate :network_path, to: :@view

  def initialize(relation, view)
    @view = view
    @relation = relation
  end

  private
  attr_reader :relation

  def data
    networks.map do |network|
      [].tap do |column|
        column << network.netzwerk&.to_cidr_s 
        column << network.description 
        column << network.location&.lid
        column << network.location.to_s
        column << network.location&.ort    
        merkmalklassen.each do |mklasse|
          column << get_merkmal(network, mklasse)
        end

        links = []
        links << show_link(network)
        links << edit_link(network)
        links << delete_link(network)
        column << links.join(' ')
      end
    end
  end

  def count
    Network.count
  end

  def total_entries
    if params[:length] == "-1"
      Network.count
    else
      networks.total_count
    end
  end

  def networks
    @networks ||= fetch_networks
  end

  def fetch_networks
    if params[:order] 
      networks = relation.order("#{sort_column} #{sort_direction}")
    else
      networks = relation
    end
    unless params[:length] == "-1"
      networks = networks.page(page).per(per_page)
    end
    networks = NetworkQuery.new(networks, search_params(params, search_columns)).all
  end

  def columns
    %w(
       networks.netzwerk 
       networks.description 
       locations.lid 
       locations.name 
       locations.ort
      ) + merkmalklassen.map {|m| "merkmal_#{m.name.downcase}" }
  end

  def search_columns
    %w(
       netzwerk 
       description 
       lid 
       location
       ort
      ) + merkmalklassen.map {|m| "merkmal_#{m.tag}" }
  end


  def merkmalklassen
    Merkmalklasse.visibles(:network, 'index')
  end
end
