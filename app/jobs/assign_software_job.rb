class AssignSoftwareJob < ApplicationJob
  queue_as :default

  def perform(options)
    @options = options.symbolize_keys!
    software_id = options.fetch(:software_id)

    relation = SoftwareRawDatum.where(software_id: nil)
    software_raw_data = SoftwareRawDataQuery.new(
                          relation,
                          software_id: software_id,
                          use_pattern: true
                        ).query
    software_raw_data.update_all(software_id: software_id)
  end
end
