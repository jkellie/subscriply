require 'spec_helper'

describe Billing::User, '.create' do
  let!(:user) { FactoryGirl.create(:user, first_name: 'Test', last_name: 'User', email: 'test@user.com') }
  let(:recurly_account) { double('Recurly::Account') }

  before do
    Billing::User.stub(:account_module).and_return(recurly_account)
    recurly_account.should_receive('create').with(
      {
        account_code: user.reload.uuid, 
        email: "test@user.com", 
        first_name: "Test", 
        last_name: "User"
      }
    )
  end

  subject do
    user.reload
    Billing::User.create(user)
  end

  it "calls recurly to create the user" do
    subject
  end
end

describe Billing::User, '.credit' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:account_module) { double('Recurly::Account') }
  let(:recurly_account) { double('recurly_account') }
  let(:recurly_adjustments) { double('recurly_adjustments') }

  before do
    Billing::User.stub(:account_module).and_return(account_module)
    Billing::User.stub(:account_on_billing).and_return(recurly_account)
    recurly_account.stub('adjustments').and_return(recurly_adjustments)
    recurly_adjustments.should_receive('create').with({
      unit_amount_in_cents: -1000,
      description:          'test credit',
      accounting_code:      'credit',
      currency:             'USD',
      quantity:             1
    })
  end

  subject do
    Billing::User.credit(user, {
      amount:          '1000',
      description:     'test credit',
      accounting_code: 'credit'
    })
  end

  it "calls recurly to create the credit" do
    subject
  end

end

describe Billing::User, '.account_on_billing' do
  let!(:user) { FactoryGirl.create(:user, first_name: 'Test', last_name: 'User', email: 'test@user.com') }
  let(:recurly_account) { double('Recurly::Account') }

  before do
    Billing::User.stub(:account_module).and_return(recurly_account)
    recurly_account.should_receive('find').with(user.reload.uuid)
  end

  subject do
    user.reload
    Billing::User.account_on_billing(user)
  end

  it "calls recurly to find the user" do
    subject
  end
end

describe Billing::User, '.update_billing_info' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:billing_info) { double('Recurly::BillingInfo')}

  before do
    Billing::User.stub(:billing_info).and_return(billing_info)
    billing_info.should_receive('update_attributes').with(token_id: '12345')
  end

  subject do
    Billing::User.update_billing_info(user, '12345')
  end

  it "calls recurly to update the new token" do
    subject
  end
end
