require 'spec_helper'

describe Billing::Notification::ExpiredSubscription, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:subscription) { FactoryGirl.create(:subscription, :canceling, uuid: 'd1b6d359a01ded71caed78eaa0fedf8e') }

  subject do
    Billing::Notification::ExpiredSubscription.new(subscription_uuid: 'd1b6d359a01ded71caed78eaa0fedf8e').perform
    Delayed::Worker.new.work_off 
  end

  it "updates the subscription to do canceled" do
    subject
    expect(subscription.reload.state).to eq('canceled')
    expect(subscription.reload.canceled_on).not_to be_nil
  end

end
