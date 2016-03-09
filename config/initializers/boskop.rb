module Boskop
  CONFIGURATION_CONTROLLER = ['merkmalklassen', 'access_types', 'line_states', 'framework_contracts'].freeze
  PERIOD_UNITS = [ 'day', 'week', 'month', 'quarter', 'year' ].freeze
  
  # set devise modules for wobauth
  def self.devise_modules
    if Settings['devise_modules'].blank?
      [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
    else
      Settings['devise_modules']
    end
  end

  # base display unit for bandwith, i.e.
  # bandwith = 2 and bandwith_base_unit = "Mbit" # => "2 Mbit"
  def self.bandwith_base_unit
    if Settings['bandwith_base_unit'].blank?
      "Mbit"
    else
      Settings['bandwith_base_unit']
    end
  end

  # relative path to app/shared/images
  def self.logo_image
    if Settings['logo_image'].blank?
      "rails.png"
    else
      Settings['logo_image']
    end
  end

  # width in mm
  def self.logo_width
    if Settings['logo_width'].blank?
      45
    else
      Settings['logo_width']
    end
  end

end

