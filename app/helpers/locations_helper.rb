module LocationsHelper
  def get_location_merkmal(location, merkmalklasse)
    return "" if (location.nil? || merkmalklasse.nil?)
    Rails.cache.fetch(["location/merkmale", location.id, merkmalklasse.id]) {
      values = location.merkmale.where(merkmalklasse_id: merkmalklasse.id).pluck(:value)
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
end
