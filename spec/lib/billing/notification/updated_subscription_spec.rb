require 'spec_helper'

describe Billing::Notification::UpdatedSubscription, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:product) { FactoryGirl.create(:product, prepend_code: 'test')}
  let!(:old_plan) { FactoryGirl.create(:plan, product: product) }
  let!(:new_plan) { FactoryGirl.create(:plan, product: product, code: 'plan')}
  let!(:subscription) { FactoryGirl.create(:subscription, :active, product: product, plan: old_plan, uuid: 'd1b6d359a01ded71caed78eaa0fedf8e', changing_on: Date.today, changing_to: '') }
  let(:plan_on_billing) { double('billing_plan', plan_code: 'plan') }
  let(:subscription_on_billing) { double('billing_subscription',
    current_period_ends_at: 1.month.from_now,
    plan: plan_on_billing
  )}

  before do
    Billing::Subscription.stub('subscription_on_billing').and_return(subscription_on_billing)
  end

  subject do
    Billing::Notification::UpdatedSubscription.new(subscription_uuid: 'd1b6d359a01ded71caed78eaa0fedf8e').perform
    Delayed::Worker.new.work_off 
  end

  it "updates the subscription to active" do
    subject
    # expect(subscription.reload.state).to eq('active')
    expect(subscription.reload.plan).to eq(new_plan)
    expect(subscription.reload.next_ship_on).not_to be_nil
    expect(subscription.reload.next_bill_on).to eq(1.month.from_now.to_date)
    expect(subscription.reload.changing_to).to be_nil
    expect(subscription.reload.changing_on).to be_nil
  end

end
