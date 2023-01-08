module NessusScansHelper
  def import_nessus_link(nessus_scan)
    button_to(import_nessus_scan_path(nessus_scan), method: :put,
              class: 'btn btn-secondary', title: t('boskop.import_nessus_scan') ) do
      raw(%Q[<i class="fas fa-arrow-alt-circle-down"></i>])
    end
  end
end
