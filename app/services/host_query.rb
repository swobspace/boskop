##
# Query object mainly for use in activities_controller
class HostQuery
  attr_reader :search_options, :query

  ##
  # possible search options:
  # * :name - hostname
  # * :description - string
  # * :ip - May be a substring or a cidr address with /mask
  # * :cpe - string
  # * :raw_os - string
  # * :fqdn - string
  # * :domain_dns - string
  # * :workgroup - string
  # * :lastseen - date
  # * :mac - macaddr (string)
  # * :vendor - string
  # * :host_category - host_categories.name (string)
  # * :lid - location.lid (string)
  #
  # please note: 
  # left_outer_join(:host_category, :location) must exist in relation.
  #
  def initialize(relation, search_options = {})
    @relation = relation
    @search_options  = search_options.symbolize_keys!
    @query   ||= build_query
  end

  ##
  # get all matching activities
  def all
    query
  end

  ## 
  # iterate with block 
  def find_each(&block)
    query.find_each(&block)
  end

  ##
  # true if the resulting query contains the specified host
  def include?(host)
    query.where(id: host.id).limit(1).any?
  end

private
  attr_accessor :relation

  def build_query
    query = relation
    search_string = [] # for global search_option :search
    search_value  = search_options.fetch(:search, false) # for global option :search
    search_options.each do |key,value|
      case key 
      when *string_fields
        query = query.where("hosts.#{key} ILIKE ?", "%#{value}%")
      when :ip
        if value =~ /\/\d{1,2}\z/
          query = query.where("ip <<= ?", value)
        else
          query = query.where("host(ip) ILIKE ?", "#{value}%")
        end
      when :lastseen
        query = query.where("to_char(lastseen, 'IYYY-MM-DD') ILIKE ?", "#{value}%")
      when :host_category
        query = query.where("host_categories.name ILIKE ?", "#{value}%")
      when :lid
        query = query.where("locations.lid ILIKE ?", "#{value}%")
      when :search
        string_fields.each do |term|
          search_string << "hosts.#{term} ILIKE :search"
        end
        if search_value =~ /\/\d{1,2}\z/
          search_string << "ip <<= '#{search_value}'"
        else
          search_string << "host(ip) ILIKE :search"
        end
        search_string << "to_char(lastseen, 'IYYY-MM-DD') ILIKE :search"
        search_string << "host_categories.name ILIKE :search"
        search_string << "locations.lid ILIKE :search"
      else
        raise ArgumentError, "unknown search option #{key}"
      end
    end
    if search_value
      query = query.where(search_string.join(' or '), search: "%#{search_value}%")
     end
    query
  end

  def string_fields
    [ :name, :description, :cpe, :raw_os, :fqdn, :domain_dns, :workgroup, :mac, :vendor ]
  end

end