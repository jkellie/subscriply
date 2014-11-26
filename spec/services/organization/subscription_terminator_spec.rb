require 'spec_helper'

describe Organization::SubscriptionTerminator, '#initialize' do
  let(:subscription) { FactoryGirl.create(:subscription) }

  subject { Organization::SubscriptionTerminator.new(subscription) }

  it "instantiates the subscription terminator" do
    expect { subject }.to_not raise_error
  end
end

describe Organization::SubscriptionTerminator, '#terminate' do
  let(:subscription) { FactoryGirl.create(:subscription, state: :active, canceled_on: nil) }
  let(:subscription_terminator) { Organization::SubscriptionTerminator.new(subscription) }

  context "with a successful termination" do
    before do
      subscription_terminator.should_receive('terminate_subscription_on_billing').and_return(true)
    end

    subject { subscription_terminator.terminate('partial') }

    it "calls billing to terminate the subscription" do
      expect(subject).to be_truthy
    end

    it "updates the correct attributes on the local subscription" do
      subject
      expect(subscription.reload.canceled?).to be_truthy
      expect(subscription.reload.canceled_on).to_not be_nil
    end
  end

  context "with a non successful termination" do
    before do
      subscription_terminator.should_receive('terminate_subscription_on_billing').and_raise(Exception.new('termination request failed'))
    end

    subject { subscription_terminator.terminate('partial') }

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
      expect(subscription_terminator.full_errors).to eq('termination request failed')
    end
  end
end
