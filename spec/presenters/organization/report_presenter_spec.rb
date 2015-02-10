require 'spec_helper'

describe Organization::ReportPresenter, 'with locations' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:locations) { FactoryGirl.create_list(:location, 3, organization: organization)}
  let!(:plan) { FactoryGirl.create(:plan, :local_pick_up, organization: organization)} 
  let!(:subscription) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: plan, location: locations.first)}
  let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: plan, location: locations.first)}
  let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: plan, location: locations.last)}

  subject {Organization::ReportPresenter}

  it 'should give correct locations' do
    params = {organization: organization, start_date: 9.days.ago, plan_type: 'local_pick_up'}
    expect(subject.new(params).locations.count).to eq(2)
  end

  it 'should give correct locations and subscriptions' do
    params = {organization: organization, start_date: 9.days.ago, plan_type: 'local_pick_up', location_id: locations.last.id}
    expect(subject.new(params).total_subscriptions_count).to eq(1)
  end

end

describe Organization::ReportPresenter, 'with plans' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:locations) { FactoryGirl.create_list(:location, 3, organization: organization)}
  let!(:local_plan) { FactoryGirl.create(:plan, :local_pick_up, organization: organization)} 
  let!(:shipped_plan) {FactoryGirl.create(:plan, :shipped, organization: organization)}
  let!(:digital_plan) {FactoryGirl.create(:plan, organization: organization)}
  let!(:digital_plan2) {FactoryGirl.create(:plan, organization: organization)}
  let!(:subscription) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: local_plan, location: locations.first)}
  let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: shipped_plan)}
  let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: digital_plan)}
  let!(:subscription4) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago, plan: digital_plan2)}

  let!(:transaction) { FactoryGirl.create(:transaction, subscription: subscription3, user:  FactoryGirl.create(:user, organization: organization))}
  let!(:transaction2) { FactoryGirl.create(:transaction, subscription: subscription4, user: FactoryGirl.create(:user, organization: organization))}

  subject {Organization::ReportPresenter}

  it 'should give correct plans' do
    params = {organization: organization, start_date: 9.days.ago, plan_type: 'digital'}
    expect(subject.new(params).plans.count).to eq(2)
  end

  it 'should give correct subscriptions with no plan filter' do
    params = {organization: organization, start_date: 9.days.ago, plan_type: 'digital'}
    expect(subject.new(params).total_subscriptions_count).to eq(2)
  end
  
  it 'should give correct subscriptions with plan filter' do
    params = {organization: organization, start_date: 9.days.ago, plan_type: 'digital', plan_id: digital_plan.id}
    expect(subject.new(params).total_subscriptions_count).to eq(1)
  end

  it '#sales_this_period' do
    params = {organization: organization, start_date: 9.days.ago, plan_type: 'digital'}
    total = [subscription3,subscription4].inject(0) do |acc, sub| 
      acc +=  (sub.transactions.sum(:amount_in_cents) / 100)
      acc
    end

    expect(subject.new(params).sales_this_period).to eq(total)
  end

end

describe Organization::ReportPresenter, '#canceled_this_period_count' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:subscription) { FactoryGirl.create(:subscription, organization: organization, canceled_on: 8.days.ago)}
  let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization, canceled_on: 4.days.ago)}
  let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization, canceled_on: 1.day.ago)}
  let(:report_presenter) { Organization::ReportPresenter.new(organization: organization, start_date: 7.days.ago, end_date: 3.days.ago)}  

  subject { report_presenter.canceled_this_period_count }
  
  it "calculates the correct number of subscriptions" do
    expect(subject).to eq(1)
  end
end

describe Organization::ReportPresenter do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:subscription) { FactoryGirl.create(:subscription, organization: organization, start_date: 8.days.ago)}
    let!(:subscription2) { FactoryGirl.create(:subscription, organization: organization, start_date: 4.days.ago)}
    let!(:subscription3) { FactoryGirl.create(:subscription, organization: organization, start_date: 1.day.ago)}
    let(:report_presenter) { Organization::ReportPresenter.new(organization: organization, start_date: 9.days.ago, end_date: 1.days.ago, plan_id: subscription.plan.id) }

    subject { report_presenter.total_subscriptions_count }
    
    it "calculates the correct number of subscriptions" do
      count = [subscription,subscription2,subscription3].inject(0) do |acc, sub|
        acc += 1 if sub.plan.id == subscription.plan.id
        acc
      end
      expect(subject).to eq(count)
    end  
end