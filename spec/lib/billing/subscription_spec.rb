require 'spec_helper'

describe Billing::Subscription, '.create_with_token' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    recurly_subscription.should_receive('create!').with(
      {
        plan_code: subscription.plan.permalink,
        account: { account_code: subscription.user.uuid, billing_info: { token_id: '12345' } }  
      }
    )
  end

  subject do
    Billing::Subscription.create_with_token(subscription, '12345')
  end

  it "calls recurly to create the subscription" do
    subject
  end
end

describe Billing::Subscription, '.create' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    recurly_subscription.should_receive('create!').with(
      {
        plan_code: subscription.plan.permalink,
        account: { account_code: subscription.user.uuid }  
      }
    )
  end

  subject do
    Billing::Subscription.create(subscription)
  end

  it "calls recurly to create the subscription" do
    subject
  end
end