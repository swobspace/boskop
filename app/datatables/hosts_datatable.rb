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
        column << host.cpe    
        column << host.raw_os 
        column << host.fqdn 
        column << host.domain_dns 
        column << host.workgroup 
        column << host.lastseen 
        column << host.mac    
        column << host.vendor 
        column << host.host_category.to_s 
        column << host.location.try(:lid) 

        links = []
        links << show_link(host)
        links << edit_link(host)
        links << delete_link(host)
        column << links.join('')
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
    hosts = relation.order("#{sort_column} #{sort_direction}")
    unless params[:length] == "-1"
      hosts = hosts.page(page).per(per_page)
    end
    hosts = HostQuery.new(hosts, search_params(params, search_columns)).all
  end

  def columns
    %w(hosts.name hosts.description host(ip) cpe raw_os fqdn domain_dns workgroup lastseen mac vendor host_categories.name locations.lid)
  end

  def search_columns
    %w(name description ip cpe raw_os fqdn domain_dns workgroup lastseen mac vendor host_category lid)
  end

end
