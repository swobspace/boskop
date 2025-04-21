class Cleanup::HostsJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    options.symbolize_keys!
    period = options.fetch(:period) { 4.month }
    
    Host.where("lastseen < ?", period.before(Time.current)).delete_all
  end
end
