require 'spec_helper'

describe Organization::DashboardPresenter, '#total_subscriptions' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:subscription) { FactoryGirl.create(:subscription, organization: organization)}
  let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization)}
  let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization)}
  let(:dashboard_presenter) { Organization::DashboardPresenter.new(organization: organization)}

  subject { dashboard_presenter.total_subscriptions }

  it "calculates the correct count" do
    expect(subject).to eq(3)  
  end
  
end

describe Organization::DashboardPresenter, '#new_this_period' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:subscription) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago)}
  let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization, start_date: 4.days.ago)}
  let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization, start_date: 1.day.ago)}
  let(:dashboard_presenter) { Organization::DashboardPresenter.new(organization: organization, start_date: 7.days.ago, end_date: 3.days.ago)}  

  subject { dashboard_presenter.new_this_period }
  
  it "calculates the correct number of subscriptions" do
    expect(subject).to eq(1)
  end
end

describe Organization::DashboardPresenter, '#canceled_this_period' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:subscription) { FactoryGirl.create(:subscription, organization: organization, canceled_on: 8.days.ago)}
  let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization, canceled_on: 4.days.ago)}
  let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization, canceled_on: 1.day.ago)}
  let(:dashboard_presenter) { Organization::DashboardPresenter.new(organization: organization, start_date: 7.days.ago, end_date: 3.days.ago)}  

  subject { dashboard_presenter.canceled_this_period }
  
  it "calculates the correct number of subscriptions" do
    expect(subject).to eq(1)
  end
end

describe Organization::DashboardPresenter, '#sales_this_period' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:user) { FactoryGirl.create(:user, organization: organization) }
  let!(:transaction) { FactoryGirl.create(:transaction,  user: user, amount_in_cents: 1000, created_at: 8.days.ago)}
  let!(:transaction2) { FactoryGirl.create(:transaction, user: user, amount_in_cents: 1000, created_at: 4.days.ago)}
  let!(:transaction3) { FactoryGirl.create(:transaction, user: user, amount_in_cents: 1000, created_at: 1.day.ago)}
  let(:dashboard_presenter) { Organization::DashboardPresenter.new(organization: organization, start_date: 7.days.ago, end_date: 3.days.ago)}

  subject { dashboard_presenter.sales_this_period }

  it "calculates the correct number of sales this period" do
    expect(subject).to eq(10)
  end
end