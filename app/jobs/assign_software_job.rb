class AssignSoftwareJob < ApplicationJob
  queue_as :default

  # AssignSoftwareJob.perform(options)
  # optional:
  # * :software_id
  #
  def perform(options = {})
    @options = options.symbolize_keys!
    software_ids = Array(options.fetch(:software_id) {Software.pluck(:id)})
    force_update = options.fetch(:force_update) { false }

    software_ids.each do |sw_id|
      software_raw_data = SoftwareRawDataQuery.new(
                            SoftwareRawDatum.all,
                            software_id: sw_id,
                            use_pattern: true
                          ).query
      mismatches = software_raw_data.where("software_id <> ?", sw_id)
      if mismatches.any?
        sw_name = Software.find(sw_id).name
        logger.warn(
                    "Mismatching entries for software id #{sw_id} [#{sw_name}]:" +
                    " raw data always assigned to other software"
                   )
        mismatches.each do |mm|
          logger.warn(
                      "software_raw_data #{mm.id} always assigned to software" + 
                      "#{mm.software_id} [#{mm.software}]"
                     )
        end
      end
      unless force_update
        # update only raw data without assigned software
        software_raw_data = software_raw_data.where(software_id: nil)
      end
      software_raw_data.update_all(software_id: sw_id)
    end
  end

private

  def logger
    @logger ||= Logger.new(File.join(Rails.root, 'log', "assign_software_job_#{Rails.env}.log"))
  end
end
