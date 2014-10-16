require 'spec_helper'

describe Billing::Plan, '.create' do
  let!(:plan) { FactoryGirl.create(:plan) }
  let(:recurly_plan) { double('Recurly::Plan') }

  before do
    Billing::Plan.stub(:plan_module).and_return(recurly_plan)
    recurly_plan.should_receive('create').with(
      {
        plan_code: plan.permalink, 
        name: plan.name, 
        description: nil, 
        unit_amount_in_cents: plan.amount_in_cents, 
        plan_interval_length: plan.charge_every, 
        trial_interval_length: plan.free_trial_length, 
        trial_interval_unit: "days"
      }
    )
  end

  subject do
    Billing::Plan.create(plan)
  end

  it "calls recurly to create the plan" do
    subject
  end
end

describe Billing::Plan, '.update' do
  let!(:plan) { FactoryGirl.create(:plan) }
  let(:recurly_plan) { double('Recurly::Plan') }
  let(:plan_on_billing) { double('plan_on_billing')}

  before do
    Billing::Plan.stub(:plan_module).and_return(recurly_plan)
    recurly_plan.stub(:find).and_return(plan_on_billing)
    plan_on_billing.should_receive('update_attributes').with(
      {
        name: plan.name, 
        description: nil, 
        unit_amount_in_cents: plan.amount_in_cents, 
        plan_interval_length: plan.charge_every, 
        trial_interval_length: plan.free_trial_length, 
      }
    )
  end

  subject do
    Billing::Plan.update(plan)
  end

  it "calls recurly to update the plan" do
    subject 
  end
end