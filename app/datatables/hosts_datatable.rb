class HostsDatatable < ApplicationDatatable
  delegate :edit_host_path, to: :@view
  delegate :host_path, to: :@view

  def initialize(relation, view)
    @view = view
    @relation = relation
  end

  private
  attr_reader :relation

  def data
    hosts.map do |host|
      [].tap do |column|
        column << host.name 
        column << host.description 
        column << host.ip.to_s
        column << host.operating_system.to_s
        column << host.cpe    
        column << host.raw_os 
        column << host.fqdn 
        column << host.domain_dns 
        column << host.workgroup 
        column << host.lastseen 
        column << host.created_at.to_date.to_s
        column << host.vuln_risk
        column << host.mac    
        column << host.oui_vendor
        column << host.serial    
        column << host.uuid    
        column << host.vendor 
        column << host.product 
        column << host.warranty_sla 
        column << host.warranty_start.to_s
        column << host.warranty_end.to_s
        column << host.host_category.to_s 
        column << host.location.try(:lid) 
        merkmalklassen.each do |mklasse|
          column << get_merkmal(host, mklasse)
        end

        links = []
        links << show_link(host)
        links << edit_link(host)
        links << delete_link(host)
        column << links.join(' ')
      end
    end
  end

  def count
    Host.count
  end

  def total_entries
    if params[:length] == "-1"
      Host.count
    else
      hosts.total_count
    end
  end

  def hosts
    @hosts ||= fetch_hosts
  end

  def fetch_hosts
    if params[:order]
      hosts = relation.order("#{sort_column} #{sort_direction}")
    else
      hosts = relation
    end
    unless params[:length] == "-1"
      hosts = hosts.page(page).per(per_page)
    end
    hosts = HostQuery.new(hosts, search_params(params, search_columns)).all
  end

  def columns
    %w(hosts.name hosts.description host(network_interfaces.ip) operating_systems.name cpe raw_os fqdn domain_dns workgroup hosts.lastseen hosts.created_at vuln_risk network_interfaces.mac network_interfaces.oui_vendor serial uuid vendor product warranty_sla warranty_start warranty_end host_categories.name locations.lid) +
    merkmalklassen.map {|m| "merkmal_#{m.name.downcase}" }
  end

  def search_columns
    %w(name description ip operating_system cpe raw_os fqdn domain_dns workgroup lastseen created_at vuln_risk mac oui_vendor serial uuid vendor product warranty_sla warranty_start warranty_end host_category lid) + 
    merkmalklassen.map {|m| "merkmal_#{m.tag}" }
  end


  def merkmalklassen
    Merkmalklasse.visibles(:host, 'index')
  end
end
