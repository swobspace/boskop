module Boskop
  CONFIGURATION_CONTROLLER = ['merkmalklassen', 'access_types', 'line_states', 'framework_contracts', 'host_categories', 'operating_systems', 'operating_system_mappings'].freeze
  PERIOD_UNITS = [ 'day', 'week', 'month', 'quarter', 'year' ].freeze
  CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'boskop.yml'))
  
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

# -- not yet used
#  ActionMailer::Base.default_url_options = {
#    host: self.host,
#    script_name: self.script_name
#  }

  Rails.application.routes.default_url_options[:host] = self.host
  Rails.application.routes.default_url_options[:script_name] = self.script_name
end
