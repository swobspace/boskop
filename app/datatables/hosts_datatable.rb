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
    hosts.total_count
    # will_paginate
    # hosts.total_entries
  end

  def hosts
    @hosts ||= fetch_hosts
  end

  def fetch_hosts
    search_string = []
    columns.each do |term|
      search_string << "#{term} like :search"
    end

    # will_paginate
    # hosts = Host.page(page).per_page(per_page)
    hosts = relation.order("#{sort_column} #{sort_direction}")
    hosts = hosts.page(page).per(per_page)
    hosts = hosts.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
  end

  def columns
    %w(hosts.name hosts.description host(ip) cpe raw_os fqdn domain_dns workgroup '' mac vendor host_categories.name locations.lid)
  end

end
