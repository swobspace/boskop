module ApplicationHelper
  include Wobapphelpers::Helpers::All

    def configuration_active_class
      if Boskop::CONFIGURATION_CONTROLLER.include?(controller.controller_name.to_s)
        "active"
      end
    end

    def orgunits_active_class
      if controller.controller_name.to_sym == :org_units
        "active"
      end
    end


end
