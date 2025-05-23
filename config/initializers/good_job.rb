# config/initializers/good_job.rb
# STDOUT.sync = true
$stdout.sync = true

Rails.application.configure do
  config.good_job = {
    execution_mode: :external,
    enable_cron: true,
    max_threads: 4,
    poll_interval: 30,
    retry_on_unhandled_error: false,
    preserve_job_records: true,
    cleanup_interval_seconds: 3600,
    cleanup_preserved_jobs_before_seconds_ago: 172800,
    cron: {
      list_scans: {
        cron: '30 5,12,16,23 * * *',
        class: "Nessus::ListScansJob",
        description: "Update list of current scans"
      },
      import_nessus_scans: {
        cron: '45 12,16,23 * * *',
        class: "Nessus::ImportScansJob",
        description: "Import Nessus Scans"
      },
      cleanup_hosts: {
        cron: '0 23 * * 6',
        class: "Cleanup::HostsJob",
        description: "Cleanup outdated hosts"
      },
      cleanup_vulnerabilities: {
        cron: '10 23 * * 6',
        class: "Cleanup::VulnerabilitiesJob",
        description: "Cleanup outdated vulnerabilities"
      }
    }
  }
end
