class NetworkInterfacesDatatable < ApplicationDatatable
  delegate :edit_network_interface_path, to: :@view
  delegate :host_path, to: :@view
  delegate :network_interface_path, to: :@view

  def initialize(relation, view)
    @view = view
    @relation = relation
  end

  private
  attr_reader :relation

  def data
    network_interfaces.map do |iface|
      [].tap do |column|
        column << iface.host.location.try(:lid)
        column << link_to(iface.host.name, host_path(iface.host))
        column << iface.ip.to_s
        column << iface.mac.to_s
        column << iface.if_description
        column << iface.lastseen.to_s
        column << iface.created_at.to_date.to_s
        links = []
        links << show_link(iface)
        links << edit_link(iface)
        links << delete_link(iface)
        column << links.join(' ')
      end
    end
  end

  def count
    NetworkInterface.count
  end

  def total_entries
    if params[:length] == "-1"
      NetworkInterface.count
    else
      network_interfaces.total_count
    end
  end

  def network_interfaces
    @network_interfaces ||= fetch_network_interfaces
  end

  def fetch_network_interfaces
    if params[:order]
      network_interfaces = relation.order(Arel.sql("#{sort_column} #{sort_direction}"))
    else
      network_interfaces = relation
    end
    unless params[:length] == "-1"
      network_interfaces = network_interfaces.page(page).per(per_page)
    end
    network_interfaces = NetworkInterfaceQuery.new(network_interfaces, search_params(params, search_columns)).all
  end

  def columns
    %w(locations.lid hosts.name host(network_interfaces.ip) network_interfaces.mac network_interfaces.if_description network_interfaces.lastseen network_interfaces.created_at)
  end

  def search_columns
    %w(lid hostname ip mac if_description lastseen created_at)
  end

end
