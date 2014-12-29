require 'spec_helper'

describe Billing::Subscription, '.create_with_token' do
  let!(:subscription) { FactoryGirl.create(:subscription, start_date: 1.day.from_now) }
  let(:recurly_subscription) { double('Recurly::Subscription')}

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    recurly_subscription.should_receive('create!').with(
      {
        plan_code: subscription.plan.permalink,
        starts_at: 1.day.from_now.to_date,
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
  let!(:subscription) { FactoryGirl.create(:subscription, start_date: 1.day.from_now) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription', uuid: '123', state: 'active', current_period_ends_at: 1.month.from_now, activated_at: Date.today) }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    subscription.stub('update_attributes').and_return(true)
    recurly_subscription.should_receive('create!').with(
      {
        plan_code: subscription.plan.permalink,
        starts_at: 1.day.from_now.to_date,
        account: { account_code: subscription.user.uuid }  
      }
    ).and_return(billing_subscription)
  end

  subject do
    Billing::Subscription.create(subscription)
  end

  it "calls recurly to create the subscription" do
    subject
  end
end

describe Billing::Subscription, '.update' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription', state: 'active', current_period_ends_at: 1.month.from_now) }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    subscription.stub('update_attributes').and_return(true)
    recurly_subscription.should_receive('find').with(subscription.uuid.gsub('-', '')).and_return(billing_subscription)
    billing_subscription.should_receive('update_attributes').with(plan_code: 'MOB_GOLD', apply_changes: 'now')
  end

  subject do
    Billing::Subscription.update(subscription, {
      plan_code: 'MOB_GOLD',
      apply_changes: 'now'
    })
  end

  it "calls recurly to update the subscription" do
    subject
  end

end

describe Billing::Subscription, '.postpone' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription') }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    subscription.stub('update_attributes').and_return(true)
    recurly_subscription.should_receive('find').with(subscription.uuid.gsub('-', '')).and_return(billing_subscription)
    billing_subscription.should_receive('postpone')
  end

  subject do
    Billing::Subscription.postpone(subscription, 2.weeks.from_now)
  end

  it "calls recurly to update the subscription" do
    subject
  end
end

describe Billing::Subscription, '.cancel' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription') }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    recurly_subscription.should_receive('find').with(subscription.uuid.gsub('-', '')).and_return(billing_subscription)
    billing_subscription.should_receive('cancel')
  end

  subject do
    Billing::Subscription.cancel(subscription)
  end

  it "calls recurly to cancel the subscription" do
    subject
  end
end

describe Billing::Subscription, '.terminate' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription') }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    subscription.stub('update_attributes').and_return(true)
    recurly_subscription.should_receive('find').with(subscription.uuid.gsub('-', '')).and_return(billing_subscription)
    billing_subscription.should_receive('terminate').with(:partial)
  end

  subject do
    Billing::Subscription.terminate(subscription, 'partial')
  end

  it "calls recurly to cancel the subscription" do
    subject
  end
end

describe Billing::Subscription, '.postpone' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription') }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    subscription.stub('update_attributes').and_return(true)
    recurly_subscription.should_receive('find').with(subscription.uuid.gsub('-', '')).and_return(billing_subscription)
    billing_subscription.should_receive('postpone')
  end

  subject do
    Billing::Subscription.postpone(subscription, 2.weeks.from_now)
  end

  it "calls recurly to update the subscription" do
    subject
  end
end

describe Billing::Subscription, '.reactivate' do
  let!(:subscription) { FactoryGirl.create(:subscription) }
  let(:recurly_subscription) { double('Recurly::Subscription')}
  let(:billing_subscription) { double('billing_subscription') }

  before do
    Billing::Subscription.stub(:subscription_module).and_return(recurly_subscription)
    subscription.stub('update_attributes').and_return(true)
    recurly_subscription.should_receive('find').with(subscription.uuid.gsub('-', '')).and_return(billing_subscription)
    billing_subscription.should_receive('reactivate')
  end

  subject do
    Billing::Subscription.reactivate(subscription)
  end

  it "calls recurly to update the subscription" do
    subject
  end
end

