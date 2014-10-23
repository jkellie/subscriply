require 'spec_helper'

describe SubscriptionCreator, '#initialize' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:plan) { FactoryGirl.create(:plan) }
  let!(:location) { FactoryGirl.create(:location) }

  subject do
    SubscriptionCreator.new(user_id: user.id, organization_id: user.organization_id, plan_id: plan.id, location_id: location.id, start_date: 1.day.from_now.strftime('%m/%d/%Y'))
  end

  it "instantiates the subscription canceler" do
    expect { subject }.to_not raise_error
  end
end

describe SubscriptionCreator, '#create' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:plan) { FactoryGirl.create(:plan) }
  let!(:location) { FactoryGirl.create(:location) }
  let(:subscription_creator) { SubscriptionCreator.new(user_id: user.id, organization_id: user.organization_id, plan_id: plan.id, location_id: location.id, start_date: 1.day.from_now.strftime('%m/%d/%Y')) }

  context 'with a successful cancelation' do
    before do
      billing_subscription = double('billing_subscription', uuid: SecureRandom.uuid, state: 'active', current_period_ends_at: 1.month.from_now.to_date, activated_at: 1.day.from_now.to_date)
      Billing::Subscription.stub('create').and_return(billing_subscription)
    end

    subject { subscription_creator.create }

    it "return true" do
      expect(subject).to be_truthy
    end

    it "does updates the subscription" do
      subject
      expect(subscription_creator.subscription.uuid).not_to be_nil
      expect(subscription_creator.subscription.state).not_to be_nil
      expect(subscription_creator.subscription.next_bill_on).not_to be_nil
      expect(subscription_creator.subscription.start_date).not_to be_nil
    end
  end

  context 'with an unsuccessful cancelation' do
    before do
      Billing::Subscription.should_receive('create').and_raise(Exception.new('failed to create subscription'))
    end

    subject { subscription_creator.create }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "tells you why it failed" do
      subject
      expect(subscription_creator.full_errors).to eq('failed to create subscription')
    end
  end
end