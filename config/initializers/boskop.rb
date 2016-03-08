module Boskop
  CONFIGURATION_CONTROLLER = ['merkmalklassen', 'access_types', 'line_states', 'framework_contracts'].freeze
  PERIOD_UNITS = [ 'day', 'week', 'month', 'quarter', 'year' ].freeze
  
  def self.devise_modules
    if Settings['devise_modules'].blank?
      [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
    else
      Settings['devise_modules']
    end
  end

  def self.bandwith_base_unit
    if Settings['bandwith_base_unit'].blank?
      "Mbit"
    else
      Settings['bandwith_base_unit']
    end
  end

  def self.logo_image
    if Settings['logo_image'].blank?
      "rails.png"
    else
      Settings['logo_image']
    end
  end

  def self.logo_width
    if Settings['logo_width'].blank?
      45
    else
      Settings['logo_width']
    end
  end

end

