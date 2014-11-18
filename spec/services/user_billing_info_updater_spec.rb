require 'spec_helper'

describe UserBillingInfoUpdater, '#initialize' do
  let(:user) { FactoryGirl.create(:user) }

  subject { UserBillingInfoUpdater.new(user) }

  it "instantiates a new UserBillingInfoUpdater object" do
    expect { subject }.to_not raise_error
  end
end

describe UserBillingInfoUpdater, '#update' do
  let(:user) { FactoryGirl.create(:user) }
  let(:billing_info_updater) { UserBillingInfoUpdater.new(user) }

  subject { billing_info_updater.update('abcdefg') }

  before do
    billing_info_updater.should_receive('update_on_billing').and_return(true)
    billing_info = double('billing_info', card_type: 'Visa', last_four: '1111', month: '12', year: '2020')
    Billing::User.stub('billing_info').and_return(billing_info)
  end

  it "udpates the billing info" do
    subject
    expect(user.reload.last_four).to eq('1111')
    expect(user.reload.card_type).to eq('Visa')
    expect(user.reload.expiration).to eq('12 / 2020')
  end
end