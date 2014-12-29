require 'spec_helper'

describe Billing::Notification::RenewedSubscription, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:subscription) { FactoryGirl.create(:subscription, :canceled, uuid: 'd1b6d359a01ded71caed78eaa0fedf8e', next_ship_on: nil, next_bill_on: nil) }
  let(:subscription_on_billing) { double('billing_subscription',
    current_period_ends_at: 1.month.from_now
  )}

  before do
    Billing::Subscription.stub('subscription_on_billing').and_return(subscription_on_billing)
  end

  subject do
    Billing::Notification::RenewedSubscription.new(subscription_uuid: 'd1b6d359a01ded71caed78eaa0fedf8e').perform
    Delayed::Worker.new.work_off 
  end

  it "updates the subscription to active" do
    subject
    expect(subscription.reload.state).to eq('active')
    expect(subscription.reload.next_ship_on).not_to be_nil
    expect(subscription.reload.next_bill_on).to eq(1.month.from_now.to_date)
    expect(subscription.reload.changing_to).to be_nil
  end

end
