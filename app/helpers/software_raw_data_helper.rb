module SoftwareRawDataHelper
  def add_software_from_raw_data(swr)
    if can? :create, Software
      icon = raw(%Q[<i class="fas fa-fw fa-cog"></i>])
      link_to icon, add_software_software_raw_datum_path(swr),
        title: I18n.t('boskop.add_software_from_raw_data'),
        class: "btn btn-secondary"
    else
      ""
    end
  end
end
