#
# Query object mainly for use in hosts_controller
#
class NetworkQuery
  attr_reader :search_options, :query
  include ActiveRecord::Sanitization::ClassMethods
  ##
  # possible search options:
  # * :netzwerk - CIDR address
  # * :description - string
  # * :lid - location.lid (string or array)
  # * :location - string
  # * :location_id - integer
  # * :ort - string
  # * :merkmal_* - string : all available merkmale
  #
  # please note: 
  # left_outer_join(:merkmale, :location) must exist in relation.
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
  # true if the resulting query contains the specified network
  def include?(network)
    query.where("networks.id = ?", network.id).limit(1).any?
  end

private
  attr_accessor :relation, :limit

  def build_query
    query = relation
    search_string = [] # for global search_option :search
    search_value  = search_options.fetch(:search, false) # for global option :search
    is_subset = search_options.fetch(:is_subset) { false }
    is_superset = search_options.fetch(:is_superset) { false }
    search_options.each do |key,value|
      case key 
      when *string_fields
        query = query.where("networks.#{key} ILIKE ?", "%#{value}%")
      when *merkmalklassen
        tag = key.to_s.sub(/merkmal_/, '')
        merkmalklasse = Merkmalklasse.where(for_object: 'Network', tag: tag).first
        query = query.where(
                'merkmale.merkmalklasse_id = :mk and merkmale.value ILIKE :value',
                 mk: merkmalklasse.id, value: "%#{value}%")
      when :limit
        @limit = value.to_i
      when :is_subset, :is_superset
        # do nothing
      when :netzwerk
        if (!!is_subset or !!is_superset)
          sub_ids = []
          super_ids = []
          if !!is_subset
            sub_ids = query.where("networks.netzwerk <<= ?", value).pluck(:id)
          end
          if !!is_superset
            super_ids = query.where("networks.netzwerk >>= ?", value).pluck(:id)
          end
          query = query.where(['networks.id in (?)', sub_ids + super_ids])
        else
          query = query.where("TEXT(networks.netzwerk) LIKE ?", "#{value}%")
        end
      when :ort
        query = query.joins("INNER JOIN addresses ON addresses.addressfor_id = locations.id AND addresses.addressfor_type = 'Location'").where("addresses.ort ILIKE :value", value: "%#{value}%")
      when :lid
        if value.kind_of? String
          lids = value.split(%r{[,; |]+})
        else
          lids = Array(value)
        end
        query = query.where("locations.lid IN (?)", lids)
      when :search
        string_fields.each do |term|
          search_string << "locations.#{term} ILIKE :search"
        end
        search_string << "locations.lid ILIKE :search"
        search_string << "TEXT(networks.netzwerk) LIKE :search"
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
    [ :description ]
  end

  def merkmalklassen
    Merkmalklasse.visibles(:network, 'index').map do |m|
      "merkmal_#{m.tag}".to_sym
    end
  end

end
