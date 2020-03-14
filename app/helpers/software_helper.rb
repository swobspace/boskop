module SoftwareHelper
  def matching_raw_software_link(sw)
    if can? :read, SoftwareRawData
      icon = raw(%Q[<i class="fas fa-fw fa-search"></i> #{I18n.t('boskop.search_software_via_pattern')}])
      link_to icon, search_software_raw_data_path({software_id: sw.id, use_pattern: true}),
        title: I18n.t('boskop.search_software_via_pattern'),
        class: "btn btn-secondary"
    else
      ""
    end
  end

  def assign_raw_software_link(sw)
    if can? :read, SoftwareRawData
      icon = raw(%Q[<i class="fas fa-fw fa-cog"></i> #{I18n.t('boskop.assign_software_via_pattern')}])
      link_to icon, assign_raw_software_software_path(sw), method: :patch,
        title: I18n.t('boskop.assign_software_via_pattern'),
        class: "btn btn-secondary"
    else
      ""
    end
  end

  def software_category_link(swcat)
    if swcat.present?
      link_to swcat.name, software_category_path(swcat)
    else
      ""
    end
  end
end
