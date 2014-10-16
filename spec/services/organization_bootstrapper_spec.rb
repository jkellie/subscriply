require 'spec_helper'

describe OrganizationBootstrapper, "#run" do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:organizer) { FactoryGirl.create(:organizer, organization: organization) }

  before do
    OrganizationBootstrapper.new(organization, organizer).run
  end
  
  it 'sets the organizer as the account owner' do
    expect(organization.account_owner).to eq(organizer)
  end

  it 'sets the organizer as super admin' do
    expect(organizer.super_admin?).to be_truthy
  end
end