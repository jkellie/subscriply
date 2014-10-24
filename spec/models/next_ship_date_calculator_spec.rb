require 'spec_helper'

describe NextShipDateCalculator, '#calculate' do



  context 'with a plan that is a local pick up' do
    let(:plan) { FactoryGirl.create(:plan, :local_pick_up) }

    context 'when teh current day of the month is between 1st and 15th of the month' do
      before do
        NextShipDateCalculator.any_instance.stub(:base_date).and_return(Date.parse('October 2, 2014'))
      end

      let!(:subscription) { FactoryGirl.create(:subscription, plan: plan) }

      subject { NextShipDateCalculator.new(subscription).calculate }

      it 'returns the 1st business day closest to the 16th of the month' do
        expect(subject.strftime('%m/%d/%Y')).to eq('10/16/2014')
      end
    end

    context 'when the current day is is after the 15th of the month' do
      before do
        NextShipDateCalculator.any_instance.stub(:base_date).and_return(Date.parse('October 24, 2014'))
      end

      let!(:subscription) { FactoryGirl.create(:subscription, plan: plan) }

      subject { NextShipDateCalculator.new(subscription).calculate }

      it 'returns the 1st business day of the following month' do
        expect(subject.strftime('%m/%d/%Y')).to eq('11/03/2014')
      end
    end
  end

  context 'with a plan that is shipped out' do
    before do
      NextShipDateCalculator.any_instance.stub(:base_date).and_return(Date.parse('October 24, 2014'))
    end

    let(:plan) { FactoryGirl.create(:plan, :shipped) }
    let!(:subscription) { FactoryGirl.create(:subscription, plan: plan) }

    subject { NextShipDateCalculator.new(subscription).calculate }

    it 'returns the next business day' do
      expect(subject.strftime('%m/%d/%Y')).to eq('10/27/2014')
    end
  end
  
end