require 'spec_helper'

describe SubscriptionUpdater, '#initialize' do
  let(:subscription) { FactoryGirl.create(:subscription) }

  subject { SubscriptionUpdater.new(subscription) }

  it "instantiates the subscription updater" do
    expect { subject }.to_not raise_error
  end
end

describe SubscriptionUpdater, '#update' do
  let(:subscription) { FactoryGirl.create(:subscription, state: :active, canceled_on: nil) }
  let(:subscription_updater) { SubscriptionUpdater.new(subscription) }
  let(:billing_subscription) { double('billing_subscription', state: 'active', current_period_ends_at: 1.month.from_now.to_date)}

  context "with a successful update" do
    before do
      subscription_updater.stub('billing_subscription').and_return(billing_subscription)
      subscription_updater.should_receive('update_subscription_on_billing').and_return(true)
    end

    subject { subscription_updater.update({plan_code: 'MOB', timeframe: 'renewal'}) }

    it "calls billing to update the subscription" do
      expect(subject).to be_truthy
    end

    it "updates the correct attributes on the local subscription" do
      subject
      expect(subscription.reload.active?).to be_truthy
      expect(subscription.reload.next_bill_on).to_not be_nil
    end
  end

  context "with a non successful update" do
    before do
      subscription_updater.should_receive('update_subscription_on_billing').and_raise(Exception.new('update request failed'))
      subscription_updater.should_not_receive('update_subscription_locally')
    end

    subject { subscription_updater.update('partial') }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "tells you why it failed" do
      subject
      expect(subscription_updater.full_errors).to eq('update request failed')
    end
  end
end
