require 'spec_helper'

describe SubscriptionWizard, '#initialize' do
  let(:organization) { FactoryGirl.create(:organization) }

  subject { SubscriptionWizard.new(organization: organization) }

  it "instantiates a new SubscriptionWizard object" do
    expect { subject }.to_not raise_error
  end
end

describe SubscriptionWizard, '#attributes=' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:subscription_wizard) { SubscriptionWizard.new(organization: organization) }

  subject do 
    subscription_wizard.attributes = {
      sales_rep_id: 12345, 
      member_number: 123456,
      phone_number: '800-abc-defg',
      email: 'test@example.com',
      first_name: 'Testy',
      last_name: 'McTesterson',
      street_address: '111 Test Lane',
      street_address_2: '#16',
      state_code: 'FL',
      city: 'Testlando',
      zip: '11111',
      start_date: 2.days.from_now,
      plan_id: 1,
      location_id: 1
    }
  end

  it "instantiates" do
    expect { subject }.to_not raise_error
  end

  it "delegates the correct attributes to the new user" do
    subject
    expect(subscription_wizard.user.name).to eq('Testy McTesterson')
    expect(subscription_wizard.user.email).to eq('test@example.com')
    expect(subscription_wizard.user.street_address).to eq('111 Test Lane')
  end

  it "delegates the correct attributes to the new subscription" do
    subject
    expect(subscription_wizard.subscription.plan_id).to eq(1)
    expect(subscription_wizard.subscription.location_id).to eq(1)
    expect(subscription_wizard.subscription.start_date).to eq(2.days.from_now.to_date)
  end
end

describe SubscriptionWizard, "#create" do
  context 'with valid attributes' do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:subscription_wizard) { SubscriptionWizard.new(organization: organization) }
    let!(:plan) { FactoryGirl.create(:plan) }

    before do
      subscription_wizard.should_receive(:create_subscription_on_recurly).and_return(true)
      subscription_wizard.should_receive(:create_user_on_recurly).and_return(true)
      subscription_wizard.should_receive(:update_cached_billing_info).and_return(true)
      subscription_wizard.attributes = {
        sales_rep_id: 12345, 
        member_number: 123456,
        phone_number: '800-abc-defg',
        email: 'test@example.com',
        first_name: 'Testy',
        last_name: 'McTesterson',
        street_address: '111 Test Lane',
        street_address_2: '#16',
        state_code: 'FL',
        city: 'Testlando',
        zip: '11111',
        start_date: 2.days.from_now,
        plan_id: plan.id,
        location_id: 1
      }
    end

    after(:each) do
      User.destroy_all
      Subscription.destroy_all
      Organization.destroy_all
    end

    subject { subscription_wizard.create }

    it "returns true" do
      expect(subject).to be_truthy
    end

    it "creates the user" do
      expect { subject }.to change{ User.count }.by(1)
    end

    it "creates the subscription" do
      expect { subject }.to change{ Subscription.count }.by(1)
    end

    it "has no errors" do
      subject
      expect(subscription_wizard.errors).to be_empty
    end

  end

  context 'with valid attributes but fails creating the subscription on recurly' do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:subscription_wizard) { SubscriptionWizard.new(organization: organization) }
    let!(:plan) { FactoryGirl.create(:plan) }

    before do
      subscription_wizard.should_receive(:create_subscription_on_recurly).and_raise(Exception.new('Failed creating subscription on recurly'))
      subscription_wizard.should_receive(:create_user_on_recurly).and_return(true)
      subscription_wizard.attributes = {
        sales_rep_id: 12345, 
        member_number: 123456,
        phone_number: '800-abc-defg',
        email: 'test@example.com',
        first_name: 'Testy',
        last_name: 'McTesterson',
        street_address: '111 Test Lane',
        street_address_2: '#16',
        state_code: 'FL',
        city: 'Testlando',
        zip: '11111',
        start_date: 2.days.from_now,
        plan_id: plan.id,
        location_id: 1
      }
    end

    after(:each) do
      User.destroy_all
      Subscription.destroy_all
      Organization.destroy_all
    end

    subject { subscription_wizard.create }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "does not create the user" do
      expect { subject }.to change{ User.count }.by(0)
    end

    it "does not create the subscription" do
      expect { subject }.to change{ Subscription.count }.by(0)
    end

    it "has an error about failing on recurly" do
      subject
      expect(subscription_wizard.errors_to_sentence).to eq('Failed creating subscription on recurly')
    end

  end
  
  context 'with invalid attributes' do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:subscription_wizard) { SubscriptionWizard.new(organization: organization) }

    before do
      subscription_wizard.attributes = {
        sales_rep_id: 12345, 
        member_number: 123456,
        phone_number: '800-abc-defg',
        email: 'test@example.com',
        first_name: nil,
        last_name: 'McTesterson',
        street_address: '111 Test Lane',
        street_address_2: '#16',
        state_code: 'FL',
        city: 'Testlando',
        zip: '11111',
        start_date: 2.days.from_now,
        plan_id: nil,
        location_id: nil
      }
    end

    after(:each) do
      User.destroy_all
      Subscription.destroy_all
      Organization.destroy_all
    end

    subject { subscription_wizard.create }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "does not create the user" do
      expect { subject }.to change{ User.count }.by(0)
    end

    it "does not create the subscription" do
      expect { subject }.to change{ Subscription.count }.by(0)
    end

    it "tells you why it failed" do
      subject
      expect(subscription_wizard.errors.count).to eq(2)
    end

  end

end