module Boskop
  CONFIGURATION_CONTROLLER = ['merkmalklassen'].freeze
  PERIOD_UNITS = [ 'day', 'week', 'month', 'quarter', 'year' ].freeze
  
  def self.devise_modules
    if Settings['devise_modules'].blank?
      [:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable]
    else
      Settings['devise_modules']
    end
  end

end

