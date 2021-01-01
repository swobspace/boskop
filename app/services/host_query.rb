#
# Query object mainly for use in hosts_controller
#
class HostQuery
  attr_reader :search_options, :query
  include ActiveRecord::Sanitization::ClassMethods
  ##
  # possible search options:
  # * :name - hostname
  # * :description - string
  # * :ip - May be a substring or a cidr address with /mask
  # * :operating_system - string
  # * :cpe - string
  # * :raw_os - string
  # * :fqdn - string
  # * :domain_dns - string
  # * :workgroup - string
  # * :lastseen - date
  # * :created_at - date
  # * :newer - lastseen >= :newer(date)
  # * :older - lastseen <= :older(date)
  # * :current - shortcut for lastseen >= 1.month.before(Date.today)
  # * :mac - macaddr (string)
  # * :oui_vendor - (string)
  # * :serial - string
  # * :uuid - string
  # * :vendor - string
  # * :product - string
  # * :warranty_start - date
  # * :warranty_start_from - date
  # * :warranty_start_until - date
  # * :host_category - host_categories.name (string)
  # * :lid - location.lid (string or array)
  # * :eol - operating_systems.eol < today (boolean)
  # * :limit - limit result (integer)
  # * :vuln_risk - string (High, Critical, ...) or 'higher' for High+Critical
  #
  # please note: 
  # left_outer_join(:host_category, :location, :operating_system) must exist in relation.
  #
  def initialize(relation, search_options = {})
    @relation       = relation
    @search_options = search_options.symbolize_keys!
    @limit          = 0
    @query          ||= build_query
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
  attr_accessor :relation, :limit

  def build_query
    query = relation
    search_string = [] # for global search_option :search
    search_value  = search_options.fetch(:search, false) # for global option :search
    search_options.each do |key,value|
      if array_values.include?(key)
        values = Array(value.gsub(/[;,] +/, ";").split(%r{[,; |]+}))
      end
      case key 
      when *string_fields
        query = query.where("hosts.#{key} ILIKE ?", "%#{value}%")
      when *merkmalklassen
        tag = key.to_s.sub(/merkmal_/, '')
        merkmalklasse = Merkmalklasse.where(for_object: 'Host', tag: tag).first
        query = query.where(
                'merkmale.merkmalklasse_id = :mk and merkmale.value ILIKE :value',
                 mk: merkmalklasse.id, value: "%#{value}%")
      when :limit
        @limit = value.to_i
      when :ip
        qstring = []
        values.each do |val|
          if val =~ /\/\d{1,2}\z/
            qstring << sanitize_sql("network_interfaces.ip <<= \'#{val}\'")
          else
            qstring << sanitize_sql("host(network_interfaces.ip) ILIKE \'#{val}%\'")
          end
        end
        query = query.where(qstring.join(' or '))
      when :mac
        mac = value.upcase.gsub(/[^0-9A-F\n]/, '').split(/\n/).first
        query = query.where("network_interfaces.mac ILIKE ?", "%#{mac}%")
      when :oui_vendor
        query = query.where("network_interfaces.oui_vendor ILIKE ?", "%#{value}%")
      when :warranty_start
        query = query.where("to_char(warranty_start, 'YYYY-MM-DD') ILIKE ?", "#{value}%")
      when :warranty_start_from
        query = query.where("warranty_start >= ?", "#{value}%")
      when :warranty_start_until
        query = query.where("warranty_start <= ?", "#{value}%")
      when :lastseen
        query = query.where("to_char(hosts.lastseen, 'YYYY-MM-DD') ILIKE ?", "#{value}%")
      when :created_at
        query = query.where("to_char(hosts.created_at, 'YYYY-MM-DD') ILIKE ?", "#{value}%")
      when :newer
        query = query.where("hosts.lastseen >= ?", "#{value}%")
      when :current
        query = query.where("hosts.lastseen >= ?", 1.month.before(Date.today))
      when :older
        query = query.where("hosts.lastseen <= ?", "#{value}%")
      when :host_category
        query = query.where("host_categories.name ILIKE ?", "%#{value}%")
      when :operating_system
        query = query.where("operating_systems.name ILIKE ?", "%#{value}%")
      when :eol
        query = query.where("operating_systems.eol < ?", Date.today)
      when :lid
        if value.kind_of? String
          lids = value.split(%r{[,; |]+})
        else
          lids = Array(value)
        end
        query = query.where("locations.lid IN (?)", lids)
      when :vuln_risk
        if value == 'higher'
          query = query.where(vuln_risk: ['High', 'Critical'])
        else
          query = query.where("hosts.vuln_risk ILIKE ?", "%#{value}%")
        end
      when :search
        string_fields.each do |term|
          search_string << "hosts.#{term} ILIKE :search"
        end
        search_string << "network_interfaces.oui_vendor ILIKE :search"
        search_string << "hosts.vuln_risk ILIKE :search"
        if search_value =~ /\/\d{1,2}\z/
          search_string << "network_interfaces.ip <<= '#{search_value}'"
        else
          search_string << "host(network_interfaces.ip) ILIKE :search"
        end
        search_string << "to_char(hosts.lastseen, 'YYYY-MM-DD') ILIKE :search"
        search_string << "host_categories.name ILIKE :search"
        search_string << "locations.lid ILIKE :search"
      else
        raise ArgumentError, "unknown search option #{key}"
      end
    end
    if search_value
      query = query.where(search_string.join(' or '), search: "%#{search_value}%")
    end
    if limit > 0
      query.limit(limit)
    else
      query
    end
  end

  def string_fields
    [ :name, :description, :cpe, :raw_os, :fqdn, :domain_dns, :workgroup, :vendor, :product, :serial, :uuid ]
  end

  def merkmalklassen
    Merkmalklasse.visibles(:host, 'index').map do |m|
      "merkmal_#{m.tag}".to_sym
    end
  end

  def array_values
    [ :ip ]
  end

end
