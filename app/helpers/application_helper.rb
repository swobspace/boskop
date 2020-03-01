module ApplicationHelper
  include Wobapphelpers::Helpers::All

  def configuration_active_class
    if Boskop::CONFIGURATION_CONTROLLER.values.flatten.include?(controller.controller_name.to_s)
      "active"
    end
  end

  def orgunits_active_class
    if [:org_units, :locations].include?(controller.controller_name.to_sym)
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

  def get_merkmal(object, merkmalklasse)
    return "" if (object.nil? || merkmalklasse.nil?)
    Rails.cache.fetch(
      ["#{object.class.name.downcase}/merkmale", object.id, merkmalklasse.id]
    ) {
      values = object.merkmale.where(merkmalklasse_id: merkmalklasse.id).pluck(:value)
      if merkmalklasse.format == 'linkindex'
        val = values.first
        if val.blank?
          ""
        else
          link_to "#{val}", raw(merkmalklasse.baselink.to_s + val.to_s), target: :blank
        end
      else
        values.join("; ").to_s
      end
    }
  end

  def dl_notes(myhash)
    list = ["<dl>"]
    myhash.each do |k,v|
      list << content_tag(:dt, k)
      list << content_tag(:dd, v)
    end
    list << ["</dl>"]
    msg = list.join.html_safe
  end
end
