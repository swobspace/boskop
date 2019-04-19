class VulnerabilitiesDatatable < ApplicationDatatable
  delegate :edit_vulnerability_path, to: :@view
  delegate :host_path, to: :@view
  delegate :vulnerability_path, to: :@view
  delegate :vulnerability_detail_path, to: :@view

  def initialize(relation, view)
    @view = view
    @relation = relation
  end

  private
  attr_reader :relation

  def data
    vulnerabilities.map do |vuln|
      [].tap do |column|
        column << vuln.host.location.try(:lid)
        column << link_to(vuln.host.ip.to_s, host_path(vuln.host))
        column << link_to(vuln.host.name, host_path(vuln.host))
        column << vuln.host.host_category.to_s
        column << vuln.host.operating_system.to_s
        column << link_to(vuln.vulnerability_detail.to_s,
                    vulnerability_detail_path(vuln.vulnerability_detail))
        column << vuln.vulnerability_detail.threat
        column << vuln.vulnerability_detail.severity.to_s
        column << vuln.lastseen.to_s
        links = []
        links << show_link(vuln)
        links << edit_link(vuln)
        links << delete_link(vuln)
        column << links.join(' ')
      end
    end
  end

  def count
    Vulnerability.count
  end

  def total_entries
    if params[:length] == "-1"
      Vulnerability.count
    else
      vulnerabilities.total_count
    end
  end

  def vulnerabilities
    @vulnerabilities ||= fetch_vulnerabilities
  end

  def fetch_vulnerabilities
    vulnerabilities = relation.order(Arel.sql("#{sort_column} #{sort_direction}"))
    unless params[:length] == "-1"
      vulnerabilities = vulnerabilities.page(page).per(per_page)
    end
    vulnerabilities = VulnerabilityQuery.new(vulnerabilities, search_params(params, search_columns)).all
  end

  def columns
    %w(locations.lid host(network_interfaces.ip) hosts.name host_categories.name operating_systems.name vulnerability_details.name vulnerability_details.threat vulnerability_details.severity vulnerabilities.lastseen)
  end

  def search_columns
    %w(lid ip hostname host_category operating_system name threat severity lastseen)
  end

end
