module NessusScansHelper
  def import_nessus_link(nessus_scan)
    link_to raw('<i class="fas fa-arrow-alt-circle-down"></i>'), 
            import_nessus_scan_path(nessus_scan),
            method: :put,
            class: 'btn btn-secondary'
  end
end
