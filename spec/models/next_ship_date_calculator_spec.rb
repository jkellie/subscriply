require 'spec_helper'

describe NextShipDateCalculator, '#calculate' do
  context 'with a plan that is a local pick up' do
    let(:plan) { FactoryGirl.create(:plan, :local_pick_up) }

    context 'with a next_bill_on that is between 1st and 15th of the month' do
      let!(:subscription) { FactoryGirl.create(:subscription, plan: plan, next_bill_on: Date.strptime('10/1/2014', '%m/%d/%Y')) }

      subject { NextShipDateCalculator.new(subscription).calculate }

      it 'returns the 1st business day closest to the 16th of the month' do
        expect(subject.strftime('%m/%d/%Y')).to eq('10/16/2014')
      end
    end

    context 'with a next_bill_on that is after the 15th of the month' do
      let!(:subscription) { FactoryGirl.create(:subscription, plan: plan, next_bill_on: Date.strptime('10/16/2014', '%m/%d/%Y')) }

      subject { NextShipDateCalculator.new(subscription).calculate }

      it 'returns the 1st business day of the following month' do
        expect(subject.strftime('%m/%d/%Y')).to eq('11/03/2014')
      end
    end
  end

  context 'with a plan that is shipped out' do
    let(:plan) { FactoryGirl.create(:plan, :shipped) }
    let!(:subscription) { FactoryGirl.create(:subscription, plan: plan, next_bill_on: Date.strptime('10/24/2014', '%m/%d/%Y')) }

    subject { NextShipDateCalculator.new(subscription).calculate }

    it 'returns the next business day' do
      expect(subject.strftime('%m/%d/%Y')).to eq('10/27/2014')
    end
  end
  
end