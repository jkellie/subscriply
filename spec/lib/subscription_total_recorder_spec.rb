require 'spec_helper'

describe SubscriptionTotalRecorder, '.run' do
  let!(:organization1) { FactoryGirl.create(:organization) }
  let!(:organization2) { FactoryGirl.create(:organization) }
  let!(:plan1) { FactoryGirl.create(:plan, organization: organization1)}
  let!(:plan2) { FactoryGirl.create(:plan, organization: organization1)}
  let!(:plan3) { FactoryGirl.create(:plan, organization: organization2)}
  let!(:plan4) { FactoryGirl.create(:plan, organization: organization2)}
  let!(:plan5) { FactoryGirl.create(:plan, organization: organization2)}
  let!(:subscription1) { FactoryGirl.create(:subscription, :active, plan: plan1, organization: organization1)}
  let!(:subscription2) { FactoryGirl.create(:subscription, :active, plan: plan2, organization: organization1)}
  let!(:subscription3) { FactoryGirl.create(:subscription, :active, plan: plan3, organization: organization2)}
  let!(:subscription4) { FactoryGirl.create(:subscription, :active, plan: plan4, organization: organization2)}
  let!(:subscription5) { FactoryGirl.create(:subscription, :active, plan: plan5, organization: organization2)}
  let!(:subscription6) { FactoryGirl.create(:subscription, :canceled, plan: plan5, organization: organization2)}

  subject { SubscriptionTotalRecorder.run }

  before do
    SubscriptionTotalRecord.destroy_all
  end

  it "calculates the totals correctly" do
    subject
    expect(SubscriptionTotalRecord.where(organization: organization1, plan_id: nil, created_at: Time.zone.now.to_date).first.total).to eq(2)
    expect(SubscriptionTotalRecord.where(organization: organization2, plan_id: nil, created_at: Time.zone.now.to_date).first.total).to eq(3)
  end

  it "calculates the totals for plans correctly" do
    subject
    expect(SubscriptionTotalRecord.where(organization: organization1, plan: plan1, created_at: Time.zone.now.to_date).first.total).to eq(1)
    expect(SubscriptionTotalRecord.where(organization: organization1, plan: plan2, created_at: Time.zone.now.to_date).first.total).to eq(1)
    expect(SubscriptionTotalRecord.where(organization: organization2, plan: plan3, created_at: Time.zone.now.to_date).first.total).to eq(1)
    expect(SubscriptionTotalRecord.where(organization: organization2, plan: plan4, created_at: Time.zone.now.to_date).first.total).to eq(1)
    expect(SubscriptionTotalRecord.where(organization: organization2, plan: plan5, created_at: Time.zone.now.to_date).first.total).to eq(1)
  end
end