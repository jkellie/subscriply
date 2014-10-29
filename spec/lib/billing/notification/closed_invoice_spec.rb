require 'spec_helper'

describe Billing::Notification::ClosedInvoice, '.perform' do
  let!(:user) { FactoryGirl.create(:user) }

  context 'with a previous existing invoice' do
    let!(:invoice) { FactoryGirl.create(:invoice, user: user, number: 1, uuid: SecureRandom.uuid, state: 'open') }
    let(:billing_invoice) { double('billing_invoice', 
      invoice_number: '1',
      total_in_cents: '100',
      created_at: 1.day.ago,
      uuid: invoice.reload.uuid,
      state: 'closed'
    )}

    before do
      Billing::Invoice.stub('invoice_on_billing').and_return(billing_invoice)
    end

    subject do
      Billing::Notification::ClosedInvoice.new(user_uuid: user.reload.uuid, invoice_number: '1').perform
    end

    it "does not create a new invoice" do
      expect{subject}.to change { Invoice.count }.by(0)
    end

    it "has the correct attributes" do
      subject
      invoice = Invoice.first
      expect(invoice.state).to eq('closed')
    end
  end

  context 'with a not previous existing invoice' do
    let(:billing_invoice) { double('billing_invoice', 
      invoice_number: '1',
      total_in_cents: '100',
      created_at: 1.day.ago,
      uuid: SecureRandom.uuid,
      state: 'closed'
    )}

    before do
      Billing::Invoice.stub('invoice_on_billing').and_return(billing_invoice)
    end

    subject do
      Billing::Notification::ClosedInvoice.new(user_uuid: user.reload.uuid, invoice_number: '1').perform
    end

    it "does create a new invoice" do
      expect{subject}.to change { Invoice.count }.by(1)
    end

    it "has the correct attributes" do
      subject
      invoice = Invoice.first
      expect(invoice.number).to eq(1)
      expect(invoice.total_in_cents).to eq(100)
      expect(invoice.state).to eq('closed')
    end
  end
  
  

end
