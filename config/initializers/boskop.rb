module Boskop
  CONFIGURATION_CONTROLLER = {
    hosts: ['host_categories', 'operating_systems', 
             'operating_system_mappings', 'mac_prefixes'], 
    lines: ['access_types', 'line_states', 'framework_contracts'], 
    framework: ['merkmalklassen'], 
  }.freeze
  PERIOD_UNITS = [ 'day', 'week', 'month', 'quarter', 'year' ].freeze
  CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'boskop.yml'))

  def self.fetch_config(attribute, default_value)
    CONFIG[attribute.to_s].presence || default_value
  end
  
  def self.devise_modules
    if CONFIG['devise_modules'].blank?
      [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
    else
      CONFIG['devise_modules']
    end
  end

  def self.bandwith_base_unit
    if CONFIG['bandwith_base_unit'].blank?
      "Mbit"
    else
      CONFIG['bandwith_base_unit']
    end
  end

  def self.default_recipient
    if CONFIG['default_recipient'].present?
      CONFIG['default_recipient']
    else
      ""
    end
  end

  def self.host
    if CONFIG['host'].present?
      CONFIG['host']
    else
      "localhost"
    end
  end

  def self.proxy
    if CONFIG['proxy'].present?
      CONFIG['proxy']
    else
      nil
    end
  end

  def self.script_name
    if CONFIG['script_name'].present?
      CONFIG['script_name']
    else
      "/"
    end
  end

  def self.mail_from
    if CONFIG['mail_from'].present?
      CONFIG['mail_from']
    else
      'boskop@localhost.local'
    end
  end

  def self.nessus_url
    if CONFIG['nessus_url'].present?
      CONFIG['nessus_url']
    else
      'https://localhost:8834'
    end
  end

  def self.nessus_ca_file
    if CONFIG['nessus_ca_file'].present?
      CONFIG['nessus_ca_file']
    else
      nil
    end
  end

  def self.responsibility_role
    if CONFIG['responsibility_role'].present?
      CONFIG['responsibility_role']
    else
      ["Vulnerabilities"]
    end
  end

  def self.always_cc
    if CONFIG['always_cc'].present?
      Array(CONFIG['always_cc'])
    else
      []
    end
  end

  def self.graylog_host
    if CONFIG['graylog_host'].present?
      CONFIG['graylog_host']
    else
      nil
    end
  end

  def self.uuid_blacklist
    if CONFIG['uuid_blacklist'].present?
      Array(CONFIG['uuid_blacklist'])
    else
      []
    end
  end

  def self.serial_blacklist
    if CONFIG['serial_blacklist'].present?
      Array(CONFIG['serial_blacklist'])
    else
      []
    end
  end

  def self.ldap_options
    if CONFIG['ldap_options'].present?
      ldapopts = CONFIG['ldap_options']
      if ldapopts.kind_of? Hash
        ldapopts = [ldapopts]
      end
      ldapopts.each do |opts|
        opts.symbolize_keys!
        opts.each do |k,v|
          opts[k] = opts[k].symbolize_keys if opts[k].kind_of? Hash
        end
      end
    else
      nil
    end
  end

  def self.enable_ldap_authentication
    return false unless self.ldap_options.present?
    fetch_config('enable_ldap_authentication', false)
  end

 ActionMailer::Base.default_url_options = {
   host: self.host,
   script_name: self.script_name
 }

  # Rails.application.routes.default_url_options[:host] = self.host
  # Rails.application.routes.default_url_options[:script_name] = self.script_name
end
