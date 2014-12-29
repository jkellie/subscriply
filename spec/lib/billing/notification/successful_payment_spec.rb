require 'spec_helper'

describe Billing::Notification::SuccessfulPayment, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:subscription) { FactoryGirl.create(:subscription, user: user, uuid: SecureRandom.uuid) }
  let!(:invoice) { FactoryGirl.create(:invoice, user: user, uuid: SecureRandom.uuid) }

  let(:billing_transaction) { double('billing_transaction', 
    transaction_type: 'charge',
    amount_in_cents: '100',
    created_at: 1.day.ago,
    uuid: SecureRandom.uuid,
    status: 'open'
  )}

  let(:billing_subscription) { double('billing_subscription', current_period_ends_at: 1.month.from_now) }

  before do
    Billing::Transaction.stub('transaction_on_billing').and_return(billing_transaction)
    Billing::Subscription.stub('subscription_on_billing').and_return(billing_subscription)
    billing_transaction.stub('subscription').and_return(subscription)
    billing_transaction.stub('invoice').and_return(invoice)
  end

  subject do
    Billing::Notification::SuccessfulPayment.new(user_uuid: user.reload.uuid, invoice_number: '1').perform
    Delayed::Worker.new.work_off 
  end

  it "creates a new transaction" do
    expect{subject}.to change { Transaction.count }.by(1)
  end

  it "has the correct attributes" do
    subject
    transaction = Transaction.first
    expect(transaction.transaction_type).to eq('charge')
    expect(transaction.amount_in_cents).to eq(100)
    expect(transaction.state).to eq('open')
  end

  it "updates the subscription next ship on" do
    subject
    expect(subscription.reload.next_ship_on).not_to be_nil
  end

  it "updates the subscription next bill on" do
    subject
    expect(subscription.reload.next_bill_on).not_to be_nil
  end

  it "updates the subscription changing to" do
    subject
    expect(subscription.reload.changing_to).to be_nil
  end

end
