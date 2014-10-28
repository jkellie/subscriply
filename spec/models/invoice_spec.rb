require 'spec_helper'

describe Invoice, '#price' do
  let(:invoice) { FactoryGirl.create(:invoice, total_in_cents: 10000) }

  it "calculates the correct price" do
    expect(invoice.price).to eq(100.0)
  end

end