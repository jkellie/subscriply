require 'spec_helper'

describe Billing::Notification::NewInvoice, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:billing_invoice) { double('billing_invoice', 
    invoice_number: '1',
    total_in_cents: '100',
    created_at: 1.day.ago,
    uuid: SecureRandom.uuid,
    state: 'open'
  )}

  before do
    Billing::Invoice.stub('invoice_on_billing').and_return(billing_invoice)
  end

  subject do
    Billing::Notification::NewInvoice.new(user_uuid: user.reload.uuid, invoice_number: '1').perform
    Delayed::Worker.new.work_off
  end

  it "creates a new invoice" do
    expect{subject}.to change { Invoice.count }.by(1)
  end

  it "has the correct attributes" do
    subject
    invoice = Invoice.first
    expect(invoice.number).to eq(1)
    expect(invoice.total_in_cents).to eq(100)
    expect(invoice.state).to eq('open')
  end

end
