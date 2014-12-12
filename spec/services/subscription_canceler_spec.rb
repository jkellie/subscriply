require 'spec_helper'

describe SubscriptionCanceler, '#initialize' do
  let(:subscription) { FactoryGirl.create(:subscription) }

  subject { SubscriptionCanceler.new(subscription) }

  it "instantiates the subscription canceler" do
    expect { subject }.to_not raise_error
  end
end

describe SubscriptionCanceler, '#cancel' do
  let(:subscription) { FactoryGirl.create(:subscription, state: :active, canceled_on: nil) }
  let(:subscription_canceler) { SubscriptionCanceler.new(subscription) }

  context "with a successful cancelation" do

    before do
      subscription_canceler.should_receive('cancel_subscription_on_billing').and_return(true)
    end

    subject { subscription_canceler.cancel }

    it "calls billing to cancel the subscription" do
      expect(subject).to be_truthy
    end

    it "updates the correct attributes on the local subscription" do
      subject
      expect(subscription.reload.canceling?).to be_truthy
      expect(subscription.reload.canceled_on).to_not be_nil
    end
  end

  context "with a non successful cancelation" do

    before do
      subscription_canceler.should_receive('cancel_subscription_on_billing').and_raise(Exception.new('cancelation request failed'))
    end

    subject { subscription_canceler.cancel }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "does not update the local subscription" do
      subject
      expect(subscription.reload.active?).to be_truthy
      expect(subscription.reload.canceled_on).to be_nil
    end

    it "tells you why it failed" do
      subject
      expect(subscription_canceler.full_errors).to eq('cancelation request failed')
    end

  end
end
