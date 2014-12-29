require 'spec_helper'

describe User, '#active_subscription_for_product, #canceling_subscription_for_product' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:product) { FactoryGirl.create(:product) }
  let!(:plan) { FactoryGirl.create(:plan, product: product) }
  let!(:subscription) { FactoryGirl.create(:subscription, user: user, plan: plan, state: 'active')}
  let!(:subscription2) { FactoryGirl.create(:subscription, user: user, plan: plan, state: 'canceling')}
  let!(:subscription3) { FactoryGirl.create(:subscription, user: user, plan: plan, state: 'canceled')}
  let!(:subscription4) { FactoryGirl.create(:subscription, user: user, plan: plan, state: 'future')}

  it "returns the correct active subscription" do
    expect(user.active_subscription_for_product(product)).to eq(subscription)
  end

  it "returns the correct canceling subscription" do
    expect(user.canceling_subscription_for_product(product)).to eq(subscription2)
  end
end

