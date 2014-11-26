require 'spec_helper'

describe Organization::UserCreditor, '#initialize' do
  let!(:user) { FactoryGirl.create(:user) }

  subject { Organization::UserCreditor.new(user) }

  it 'initializes the user_creditor' do
    expect { subject }.to_not raise_error
  end
end

describe Organization::UserCreditor, '#attributes=' do
  let!(:user) { Organization::FactoryGirl.create(:user) }
  let(:user_creditor) { Organization::UserCreditor.new(user) }

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

describe Organization::UserCreditor, '#create' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:user_creditor) { Organization::UserCreditor.new(user) }

  context 'with a successful credit' do
    before do
      user_creditor.attributes = {
        amount: '100',
        description: 'test',
        accounting_code: 'test'
      }
      user_creditor.should_receive(:create_credit_on_billing).and_return(true)
    end

    subject { user_creditor.create }

    it "calls billing to create the credit" do
      subject
    end
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