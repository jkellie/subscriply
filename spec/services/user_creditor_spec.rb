require 'spec_helper'

describe UserCreditor, '#initialize' do
  let!(:user) { FactoryGirl.create(:user) }

  subject { UserCreditor.new(user) }

  it 'initializes the user_creditor' do
    expect { subject }.to_not raise_error
  end
end

describe UserCreditor, '#attributes=' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:user_creditor) { UserCreditor.new(user) }

  subject do
    user_creditor.attributes = {
      amount: '100',
      description: 'test',
      accounting_code: 'test'
    }
  end

  it "sets the attributes" do
    expect { subject }.to_not raise_error
  end
end

describe UserCreditor, '#create' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:user_creditor) { UserCreditor.new(user) }

  context 'with a successful credit' do
    before do
      user_creditor.attributes = {
        amount: '100',
        description: 'test',
        accounting_code: 'test'
      }
      user_creditor.should_receive(:create_credit_on_billing).and_return(true)
      user_creditor.should_receive(:create_credit_locally).and_return(true)
    end

    subject { user_creditor.create }

    it "calls billing to create the credit" do
      subject
    end

    skip "it creates a local credit"
  end

  context 'with a non successful credit' do
    before do
      user_creditor.attributes = {
        amount: '100',
        description: 'test',
        accounting_code: 'test'
      }
      user_creditor.should_receive(:create_credit_on_billing).and_raise(Exception.new('request failed'))
    end

    subject { user_creditor.create }

    it "returns false" do
      expect(subject).to be_falsey
    end

    it "has an error telling why it failed" do
      subject
      expect(user_creditor.errors.full_messages.to_sentence).to eq('request failed')
    end
  end  

end