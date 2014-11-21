require 'spec_helper'

describe Plan, '.subscribed?' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:active_user) { FactoryGirl.create(:user, organization: organization) }
  let!(:inactive_user) { FactoryGirl.create(:user, organization: organization) }
  let!(:never_user) { FactoryGirl.create(:user, organization: organization)}
  let!(:plan) { FactoryGirl.create(:plan, organization: organization) }
  let!(:active_subscription) { FactoryGirl.create(:subscription, :active, plan: plan, user: active_user) }
  let!(:inactive_subscription) { FactoryGirl.create(:subscription, :canceled, plan: plan, user: inactive_user) }

  it "returns true if user has an active subscription" do
    expect(plan.subscribed?(active_user)).to be_truthy
  end

  it "returns false if the user does not have an active subscription" do
    expect(plan.subscribed?(inactive_user)).to be_falsey
  end

  it "returns false if the user has never had a subscription for it" do
    expect(plan.subscribed?(never_user)).to be_falsey
  end

end