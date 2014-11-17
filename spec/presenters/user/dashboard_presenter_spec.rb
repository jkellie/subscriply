require 'spec_helper'

describe User::DashboardPresenter, '#products' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:user) { FactoryGirl.create(:user, organization: organization) }
  let!(:plan1) { FactoryGirl.create(:plan, product: product1, organization: organization)}
  let!(:plan2) { FactoryGirl.create(:plan, product: product2, organization: organization)}
  let!(:plan3) { FactoryGirl.create(:plan, product: product3, organization: organization)}
  let!(:product1) { FactoryGirl.create(:product, organization: organization) }
  let!(:product2) { FactoryGirl.create(:product, organization: organization) }
  let!(:product3) { FactoryGirl.create(:product, organization: organization) }
  let!(:subscription) { FactoryGirl.create(:subscription, plan: plan1, organization: organization, user: user, state: 'active')}
  let!(:subscription2) { FactoryGirl.create(:subscription, plan: plan2, organization: organization, user: user, state: 'canceled')}
  let(:dashboard_presenter) { User::DashboardPresenter.new(user: user) }

  subject { dashboard_presenter.products }

  it "lists the active product first" do
    expect(subject.first).to eq(product1)
  end

  it "lists the canceled product second" do
    expect(subject.second).to eq(product2)
  end

  it "lists the product for which the user has never had a subscription to third" do
    expect(subject.third).to eq(product3)
  end
end