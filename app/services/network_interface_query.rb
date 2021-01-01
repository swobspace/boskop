##
# Query object mainly for use in network_interfaces_controller
#
class NetworkInterfaceQuery
  attr_reader :search_options, :query

  ##
  # possible search options:
  # * :lid - host.location.lid (string or array)
  # * :hostname - string
  # * :ip - May be a substring or a cidr address with /mask
  # * :mac - string
  # * :if_description - string
  # * :lastseen - date (ILIKE)
  # * :created_at - date (ILIKE)
  # * :at - date (exact match)
  # * :newer - lastseen >= :newer(date)
  # * :older - lastseen <= :older(date)
  # * :current - shortcut for lastseen >= 1.month.before(Date.today)
  # * :limit - limit result (integer)
  #
  # please note: 
  # left_outer_joins(host: [ :location ]
  # )
  # must exist in relation.
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
  def include?(iface)
    query.where(id: iface.id).limit(1).any?
  end

private
  attr_accessor :relation, :limit

  def build_query
    query = relation
    search_string = [] # for global search_option :search
    search_value  = search_options.fetch(:search, false) # for global option :search
    search_options.each do |key,value|
      case key 
      when :limit
        @limit = value.to_i
      when :ip
        if value =~ /\/\d{1,2}\z/
          query = query.where("network_interfaces.ip <<= ?", value)
        else
          query = query.where("host(network_interfaces.ip) ILIKE ?", "#{value}%")
        end
      when :mac
        mac = value.upcase.gsub(/[^0-9A-F\n]/, '').split(/\n/).first
        query = query.where("network_interfaces.mac ILIKE ?", "%#{mac}%")
      when :lastseen
        query = query.where("to_char(network_interfaces.lastseen, 'YYYY-MM-DD') ILIKE ?", "#{value}%")
      when :created_at
        query = query.where("to_char(network_interfaces.created_at, 'YYYY-MM-DD') ILIKE ?", "#{value}%")
      when :at
        query = query.where("network_interfaces.lastseen = ?", "#{value}")
      when :newer, :since
        query = query.where("network_interfaces.lastseen >= ?", "#{value}%")
      when :current
        query = query.where("network_interfaces.lastseen >= ?", 1.month.before(Date.today))
      when :older
        query = query.where("network_interfaces.lastseen <= ?", "#{value}%")
      when :hostname
        query = query.where("hosts.name ILIKE ?", "%#{value}%")
      when :if_description
        query = query.where("network_interfaces.if_description ILIKE ?", "%#{value}%")
      when :lid
        lids = value.split(%r{[,; |]+})
        query = query.where("locations.lid IN (?)", lids)
      when :search
        if search_value =~ /\/\d{1,2}\z/
          search_string << "network_interfaces.ip <<= '#{search_value}'"
        else
          search_string << "host(network_interfaces.ip) ILIKE :search"
        end
        search_string << "to_char(network_interfaces.lastseen, 'YYYY-MM-DD') ILIKE :search"
        search_string << "hosts.name ILIKE :search"
        search_string << "network_interfaces.if_description ILIKE :search"
        search_string << "network_interfaces.mac ILIKE :search"
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
end
