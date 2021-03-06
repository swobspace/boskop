class SoftwareRawDataDatatable < ApplicationDatatable
  delegate :edit_software_raw_datum_path, to: :@view
  delegate :software_raw_datum_path, to: :@view
  delegate :add_software_from_raw_data, to: :@view
  delegate :software_path, to: :@view

  def initialize(relation, view, filter = {})
    @view = view
    @relation = relation
    @filter = filter || {}
  end

  private
  attr_reader :relation, :filter

  def data
    software_raw_data.map do |swr|
      [].tap do |column|
        column << swr.name
        column << swr.version
        column << swr.vendor
        column << swr.hosts.count
        column << swr.operating_system
        column << swr.lastseen.to_s
        column << swr.source
        column << software_link(swr)
        links = []
        links << show_link(swr)
        links << edit_link(swr)
        links << add_software_from_raw_data(swr)
        column << links.join(' ')
      end
    end
  end

  def count
    SoftwareRawDatum.count
  end

  def total_entries
    if params[:length] == "-1"
      SoftwareRawDatum.count
    else
      software_raw_data.total_count
    end
  end

  def software_raw_data
    @software_raw_data ||= fetch_software_raw_data
  end

  def fetch_software_raw_data
    software_raw_data = relation.order(Arel.sql("#{sort_column} #{sort_direction}"))
    unless params[:length] == "-1"
      software_raw_data = software_raw_data.page(page).per(per_page)
    end
    software_raw_data = SoftwareRawDataQuery.new(
                          software_raw_data.left_outer_joins(:software), 
                          search_params(params, search_columns).merge(filter))
                        .all
  end

  def columns
    %w(
      software_raw_data.name
      software_raw_data.version
      software_raw_data.vendor
      software_raw_data.count
      software_raw_data.operating_system
      software_raw_data.lastseen
      software_raw_data.source
      software.name
    )
  end

  def search_columns
    %w(
      name
      version
      vendor
      count
      operating_system
      lastseen
      source
      software
    )
  end

  def software_link(swr)
    if swr.software.nil?
      ""
    else
      link_to swr.software.to_s, software_path(swr.software)
    end
  end

end
