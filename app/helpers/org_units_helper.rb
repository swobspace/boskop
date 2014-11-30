module OrgUnitsHelper
  def get_orgunit_merkmal(orgunit, merkmalklasse)
    Rails.cache.fetch(["orgunit/merkmale", orgunit.id, merkmalklasse.id]) {
      values = orgunit.merkmale.where(merkmalklasse_id: merkmalklasse.id).pluck(:value)
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
