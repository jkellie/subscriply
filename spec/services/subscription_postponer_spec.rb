require 'spec_helper'

describe SubscriptionPostponer, '#initialize' do
  let!(:subscription) { FactoryGirl.create(:subscription) }

  subject { SubscriptionPostponer.new(subscription) }

  it 'initializes the subscription postponer' do
    expect { subject }.to_not raise_error
  end
end

describe SubscriptionPostponer, '#postpone' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:subscription_postponer ) { SubscriptionPostponer.new(subscription) }

  context 'with a successful postpone' do
    before do
      subscription_postponer.should_receive(:postpone_on_billing).and_return(true)
      subscription_postponer.should_receive(:update_local_subscription).and_return(true)
    end

    subject { subscription_postponer.postpone(1.day.from_now.to_date) }

    it "returns true if successful" do
      expect(subject).to be_truthy
    end
  end

  context 'with a non successful postpone' do
    before do
      subscription_postponer.should_receive(:postpone_on_billing).and_raise(Exception.new('the request failed'))
    end

    subject { subscription_postponer.postpone(1.day.from_now.to_date) }

    it "does something" do
      expect(subject).to be_falsey
    end

    it "sets the errors" do
      subject
      expect(subscription_postponer.full_errors).to eq('the request failed')
    end
  end
end
