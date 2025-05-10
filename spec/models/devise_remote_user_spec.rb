require 'rails_helper'

RSpec.describe DeviseRemoteUser do
  #
  # wobauth uses lowercase usernames, so ensure that REMOTE_USER is lowercase
  #
  if Boskop.devise_modules.include?(:remote_user_authenticatable)
    describe "::remote_user_id" do
      let(:mock_env) { { 'REMOTE_USER' => 'Max.Mustermann@example.com' } }
      it { expect(DeviseRemoteUser.remote_user_id(mock_env)).to eq("max.mustermann@example.com") }
    end
  end
end
