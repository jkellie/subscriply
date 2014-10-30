require 'spec_helper'

describe Billing::NotificationFactory, '.build_notification' do
  
  subject { Billing::NotificationFactory.build_notification(body) }

  context 'with a new invoice notification' do
    let(:body) { 
      %Q{<new_invoice_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verana</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <invoice>
          <uuid>ffc64d71d4b5404e93f13aac9c63b007</uuid>
          <subscription_id nil="true"></subscription_id>
          <state>open</state>
          <invoice_number type="integer">1000</invoice_number>
          <po_number></po_number>
          <vat_number></vat_number>
          <total_in_cents type="integer">1000</total_in_cents>
          <currency>USD</currency>
          <date type="datetime">2014-01-01T20:21:44Z</date>
          <closed_at type="datetime" nil="true"></closed_at>
        </invoice>
      </new_invoice_notification>}
    }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::NewInvoice)
    end
  end

  context 'with a closed invoice notification' do
    let(:body) { 
      %Q{<closed_invoice_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verana</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <invoice>
          <uuid>ffc64d71d4b5404e93f13aac9c63b007</uuid>
          <subscription_id nil="true"></subscription_id>
          <state>collected</state>
          <invoice_number type="integer">1000</invoice_number>
          <po_number></po_number>
          <vat_number></vat_number>
          <total_in_cents type="integer">1100</total_in_cents>
          <currency>USD</currency>
          <date type="datetime">2014-01-01T20:20:29Z</date>
          <closed_at type="datetime">2014-01-01T20:24:02Z</closed_at>
        </invoice>
      </closed_invoice_notification>}
    }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::ClosedInvoice)
    end
  end

  context 'with a past due invoice notification' do
    let(:body) { 
      %Q{<past_due_invoice_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verana</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <invoice>
          <uuid>ffc64d71d4b5404e93f13aac9c63b007</uuid>
          <subscription_id nil="true"></subscription_id>
          <state>past_due</state>
          <invoice_number type="integer">1000</invoice_number>
          <po_number></po_number>
          <vat_number></vat_number>
          <total_in_cents type="integer">1100</total_in_cents>
          <currency>USD</currency>
          <date type="datetime">2014-01-01T20:20:29Z</date>
          <closed_at type="datetime">2014-01-01T20:24:02Z</closed_at>
        </invoice>
      </past_due_invoice_notification>}
    }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::PastDueInvoice)
    end
  end

  context 'with a successful payment notification' do
    let(:body) { 
      %Q{<successful_payment_notification>
          <account>
            <account_code>1</account_code>
            <username nil="true">verena</username>
            <email>verena@example.com</email>
            <first_name>Verena</first_name>
            <last_name>Example</last_name>
            <company_name nil="true">Company, Inc.</company_name>
          </account>
          <transaction>
            <id>a5143c1d3a6f4a8287d0e2cc1d4c0427</id>
            <invoice_id>1974a09kj90s0789dsf099798326881c</invoice_id>
            <invoice_number type="integer">2059</invoice_number>
            <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
            <action>purchase</action>
            <date type="datetime">2009-11-22T13:10:38Z</date>
            <amount_in_cents type="integer">1000</amount_in_cents>
            <status>success</status>
            <message>Bogus Gateway: Forced success</message>
            <reference></reference>
            <source>subscription</source>
            <cvv_result code=""></cvv_result>
            <avs_result code=""></avs_result>
            <avs_result_street></avs_result_street>
            <avs_result_postal></avs_result_postal>
            <test type="boolean">true</test>
            <voidable type="boolean">true</voidable>
            <refundable type="boolean">true</refundable>
          </transaction>
        </successful_payment_notification>}
      }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::SuccessfulPayment)
    end
  end

  context 'with a failed payment notification' do
    let(:body) { 
      %Q{<failed_payment_notification>
          <account>
            <account_code>1</account_code>
            <username nil="true">verena</username>
            <email>verena@example.com</email>
            <first_name>Verena</first_name>
            <last_name>Example</last_name>
            <company_name nil="true">Company, Inc.</company_name>
          </account>
          <transaction>
            <id>a5143c1d3a6f4a8287d0e2cc1d4c0427</id>
            <invoice_id>8fjk3sd7j90s0789dsf099798jkliy65</invoice_id>
            <invoice_number type="integer">2059</invoice_number>
            <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
            <action>purchase</action>
            <date type="datetime">2009-11-22T13:10:38Z</date>
            <amount_in_cents type="integer">1000</amount_in_cents>
            <status>Declined</status>
            <message>This transaction has been declined</message>
            <reference></reference>
            <source>subscription</source>
            <cvv_result code=""></cvv_result>
            <avs_result code=""></avs_result>
            <avs_result_street></avs_result_street>
            <avs_result_postal></avs_result_postal>
            <test type="boolean">true</test>
            <voidable type="boolean">false</voidable>
            <refundable type="boolean">false</refundable>
          </transaction>
        </failed_payment_notification>}
      }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::FailedPayment)
    end
  end

  context 'with a void payment notification' do
    let(:body) { 
      %Q{<void_payment_notification>
          <account>
            <account_code>1</account_code>
            <username nil="true"></username>
            <email>verena@example.com</email>
            <first_name>Verena</first_name>
            <last_name>Example</last_name>
            <company_name nil="true"></company_name>
          </account>
          <transaction>
            <id>4997ace0f57341adb3e857f9f7d15de8</id>
            <invoice_id>ffc64d71d4b5404e93f13aac9c63b007</invoice_id>
            <invoice_number type="integer">2059</invoice_number>
            <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
            <action>purchase</action>
            <date type="datetime">2010-10-05T23:00:50Z</date>
            <amount_in_cents type="integer">235</amount_in_cents>
            <status>void</status>
            <message>Test Gateway: Successful test transaction</message>
            <reference></reference>
            <source>subscription</source>
            <cvv_result code="M">Match</cvv_result>
            <avs_result code="D">Street address and postal code match.</avs_result>
            <avs_result_street></avs_result_street>
            <avs_result_postal></avs_result_postal>
            <test type="boolean">true</test>
            <voidable type="boolean">false</voidable>
            <refundable type="boolean">false</refundable>
          </transaction>
        </void_payment_notification>}
      }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::VoidPayment)
    end
  end

  context 'with a successful refund notification' do
    let(:body) { 
      %Q{<successful_refund_notification>
          <account>
            <account_code>1</account_code>
            <username nil="true"></username>
            <email>verena@example.com</email>
            <first_name>Verena</first_name>
            <last_name>Example</last_name>
            <company_name nil="true"></company_name>
          </account>
          <transaction>
            <id>2c7a2e30547e49869efd4e8a44b2be34</id>
            <invoice_id>ffc64d71d4b5404e93f13aac9c63b007</invoice_id>
            <invoice_number type="integer">2059</invoice_number>
            <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
            <action>credit</action>
            <date type="datetime">2010-10-06T20:37:55Z</date>
            <amount_in_cents type="integer">235</amount_in_cents>
            <status>success</status>
            <message>Bogus Gateway: Forced success</message>
            <reference></reference>
            <source>subscription</source>
            <cvv_result code=""></cvv_result>
            <avs_result code=""></avs_result>
            <avs_result_street></avs_result_street>
            <avs_result_postal></avs_result_postal>
            <test type="boolean">true</test>
            <voidable type="boolean">true</voidable>
            <refundable type="boolean">false</refundable>
          </transaction>
        </successful_refund_notification>}
      }

    it 'sends a message to the right notification class' do
      expect(subject.class).to eq(Billing::Notification::SuccessfulRefund)
    end
  end

end
