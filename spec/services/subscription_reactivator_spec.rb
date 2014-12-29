require 'spec_helper'

describe SubscriptionReactivator, '#initialize' do
  let(:subscription) { FactoryGirl.create(:subscription) }

  subject { SubscriptionReactivator.new(subscription) }

  it "instantiates the subscription reactivator" do
    expect { subject }.to_not raise_error
  end
end

describe SubscriptionReactivator, '#reactivate' do
  let(:subscription) { FactoryGirl.create(:subscription, state: :canceling, canceled_on: 1.week.ago) }
  let(:subscription_reactivator) { SubscriptionReactivator.new(subscription) }

  context "with a successful reactivation" do

    before do
      subscription_reactivator.should_receive('reactivate_subscription_on_billing').and_return(true)
    end

    subject { subscription_reactivator.reactivate }

    it "calls billing to reactivate the subscription" do
      expect(subject).to be_truthy
    end

    it "updates the correct attributes on the local subscription" do
      subject
      expect(subscription.reload.active?).to be_truthy
      expect(subscription.reload.canceled_on).to be_nil
    end
  end

  context "with a non successful reactivation" do

    before do
      subscription_reactivator.should_receive('reactivate_subscription_on_billing').and_raise(Exception.new('reactivation request failed'))
    end

    subject { subscription_reactivator.reactivate }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "does not update the local subscription" do
      subject
      expect(subscription.reload.canceling?).to be_truthy
      expect(subscription.reload.canceled_on).to_not be_nil
    end

    it "tells you why it failed" do
      subject
      expect(subscription_reactivator.full_errors).to eq('reactivation request failed')
    end

  end
end
