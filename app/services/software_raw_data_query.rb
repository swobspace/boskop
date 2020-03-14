#d#
# Query object mainly for use in software_raw_data_controller
#
class SoftwareRawDataQuery
  attr_reader :search_options, :query

  ##
  # possible search options:
  # * :name - string
  # * :lastseen - date
  # * :created_at - date
  # * :newer - lastseen >= :newer(date)
  # * :older - lastseen <= :older(date)
  # * :pattern - Array of Hashes with postgres regexp [:name, :vendor, :version, :operating_system]
  # * :software_id - integer
  # * :no_software_id - boolean: raw data without assigned software
  # * :software - search for software.name
  # * :use_pattern - boolean (only with software_id)
  # * :limit - limit result (integer)
  #
  # please note: relation should have:
  #   left_outer_joins(:software)
  #
  def initialize(relation, search_options = {})
    @relation       = relation
    @search_options = search_options.symbolize_keys!
    @limit          = 0
    @use_pattern    = @search_options.fetch(:use_pattern) { false }
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
  # true if the resulting query contains the specified swr
  def include?(swr)
    query.where(id: swr.id).limit(1).any?
  end

private
  attr_accessor :relation, :limit, :use_pattern

  def build_query
    query = relation
    search_string = [] # for global search_option :search
    search_value  = search_options.fetch(:search, false) # for global option :search
    search_options.each do |key,value|
      case key 
      when *string_fields
        query = query.where("software_raw_data.#{key} ILIKE ?", "%#{value}%")
      when :limit
        @limit = value.to_i
      when :version
        query = query.where("software_raw_data.version ILIKE ?", "#{value}%")
      when :lastseen
        query = query.where("to_char(software_raw_data.lastseen, 'IYYY-MM-DD') ILIKE ?", "#{value}%")
      when :created_at
        query = query.where("to_char(software_raw_data.created_at, 'IYYY-MM-DD') ILIKE ?", "#{value}%")
      when :newer
        query = query.where("software_raw_data.lastseen >= ?", "#{value}%")
      when :current
        query = query.where("software_raw_data.lastseen >= ?", 1.month.before(Date.today))
      when :older
        query = query.where("software_raw_data.lastseen <= ?", "#{value}%")
      when :pattern
        query = pattern_query(query, value)
      when :use_pattern
      when :software_id, :no_software_id
        if key == :no_software_id
          query = query.where(software_id: nil)
        elsif use_pattern
          sw = Software.find(value)
          if sw.pattern.empty?
            query = query.none
          else
            query = pattern_query(query, sw.pattern)
          end
        else
          query = query.where(software_id: value)
        end
      when :count
        query = query.where(count: value)
      when :software
        query = query.where("software.name ILIKE ?", "%#{value}%")
      when :search
        string_fields.each do |term|
          search_string << "software_raw_data.#{term} ILIKE :search"
        end
        search_string << "to_char(software_raw_data.lastseen, 'IYYY-MM-DD') ILIKE :search"
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
    [ :name, :vendor, :operating_system, :source ]
  end

  def pattern_query(query, value)
    if value.kind_of? Hash
      value = [value]
    end
    or_strings = []
    value.each do |hash|
      and_strings = []
      hash.each_pair do |k,v|
        and_strings << "software_raw_data.#{k} ~* \'#{v}\'"
      end
      or_strings << "(#{and_strings.join(' AND ')})"
    end
    all_strings = or_strings.join(" OR ")
    query.where(all_strings)
  end

end
