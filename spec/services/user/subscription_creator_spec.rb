require 'spec_helper'

describe User::SubscriptionCreator, '#initialize' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:organization) { FactoryGirl.create(:organization) }

  subject { User::SubscriptionCreator.new(organization: organization, user: user) }

  it "instantiates a new SubscriptionCreator object" do
    expect { subject }.to_not raise_error
  end
end

describe User::SubscriptionCreator, '#attributes=' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:user) { FactoryGirl.create(:user, organization: organization) }
  let!(:subscription_creator) { User::SubscriptionCreator.new(organization: organization, user: user) }

  subject do 
    subscription_creator.attributes = {
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
    expect(subscription_creator.user.name).to eq('Testy McTesterson')
    expect(subscription_creator.user.email).to eq('test@example.com')
    expect(subscription_creator.user.street_address).to eq('111 Test Lane')
  end

  it "delegates the correct attributes to the new subscription" do
    subject
    expect(subscription_creator.subscription.plan_id).to eq(1)
    expect(subscription_creator.subscription.location_id).to eq(1)
    expect(subscription_creator.subscription.start_date).to eq(2.days.from_now.to_date)
  end
end

describe User::SubscriptionCreator, "#create" do
  context 'with valid attributes' do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:user) { FactoryGirl.create(:user, organization: organization, street_address: '123 Test Lane') }
    let!(:subscription_creator) { User::SubscriptionCreator.new(organization: organization, user: user) }
    let!(:plan) { FactoryGirl.create(:plan) }

    before do
      subscription_creator.should_receive(:create_subscription_on_billing).and_return(true)
      subscription_creator.should_receive(:update_subscription_locally).and_return(true)
      subscription_creator.attributes = {
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

    subject { subscription_creator.create }

    it "returns true" do
      expect(subject).to be_truthy
    end

    it "updates the user" do
      subject
      expect(user.reload.street_address).to eq('111 Test Lane')
    end

    it "creates the subscription" do
      expect { subject }.to change{ Subscription.count }.by(1)
    end

    it "updates the next ship on" do
      expect { subject }.to change{ subscription_creator.subscription.next_ship_on }
    end

    it "has no errors" do
      subject
      expect(subscription_creator.errors).to be_empty
    end

  end

  context 'with valid attributes but fails creating the subscription on recurly' do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:user) { FactoryGirl.create(:user, organization: organization)}
    let!(:subscription_creator) { User::SubscriptionCreator.new(organization: organization, user: user) }
    let!(:plan) { FactoryGirl.create(:plan) }

    before do
      subscription_creator.should_receive(:create_subscription_on_billing).and_raise(Exception.new('Failed creating subscription on recurly'))
      subscription_creator.attributes = {
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

    subject { subscription_creator.create }

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
      expect(subscription_creator.full_errors).to eq('Failed creating subscription on recurly')
    end

  end
  
  context 'with invalid attributes' do
    let!(:organization) { FactoryGirl.create(:organization) }
    let!(:user) { FactoryGirl.create(:user, organization: organization)}
    let!(:subscription_creator) { User::SubscriptionCreator.new(organization: organization, user: user) }

    before do
      subscription_creator.attributes = {
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

    subject { subscription_creator.create }

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
      expect(subscription_creator.errors.count).to eq(1)
    end

  end

end