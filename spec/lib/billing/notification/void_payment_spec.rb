require 'spec_helper'

describe Billing::Notification::VoidPayment, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:subscription) { FactoryGirl.create(:subscription, user: user, uuid: SecureRandom.uuid) }
  let!(:invoice) { FactoryGirl.create(:invoice, user: user, uuid: SecureRandom.uuid) }

  let(:billing_transaction) { double('billing_transaction', 
    transaction_type: 'charge',
    amount_in_cents: '100',
    created_at: 1.day.ago,
    uuid: SecureRandom.uuid,
    status: 'void'
  )}

  before do
    Billing::Transaction.stub('transaction_on_billing').and_return(billing_transaction)
    billing_transaction.stub('subscription').and_return(subscription)
    billing_transaction.stub('invoice').and_return(invoice)
  end

  subject do
    Billing::Notification::VoidPayment.new(user_uuid: user.reload.uuid, invoice_number: '1').perform
    Delayed::Worker.new.work_off 
  end

  it "creates a new trnasaction" do
    expect{subject}.to change { Transaction.count }.by(1)
  end

  it "has the correct attributes" do
    subject
    transaction = Transaction.first
    expect(transaction.transaction_type).to eq('charge')
    expect(transaction.amount_in_cents).to eq(100)
    expect(transaction.state).to eq('void')
  end

end
