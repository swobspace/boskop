require 'rails_helper'

RSpec.describe Cleanup::HostsJob, type: :job do
  describe '#perform_later' do
    it 'matches with enqueued job without args' do
      expect do
        Cleanup::HostsJob.perform_later
      end.to have_enqueued_job(Cleanup::HostsJob)
    end

    it 'matches with enqueued job some args' do
      expect do
        Cleanup::HostsJob.perform_later(period: 4.month)
      end.to have_enqueued_job(Cleanup::HostsJob).with(period: 4.month)
    end
  end
end

