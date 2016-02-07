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

  def link_to_attribute(obj, attribute)
    if obj.respond_to?(attribute)
      return "--" if obj.send(attribute).nil?
      title = obj.send(attribute).try(:to_str) || obj.send(attribute).to_s
      if can? :read, obj.send(attribute)
        link_to(title, polymorphic_path(obj.send(attribute)))
      else
        title
      end
    else
      raise RuntimeError
    end
  end

end
