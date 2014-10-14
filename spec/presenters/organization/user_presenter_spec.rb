require 'spec_helper'

describe Organization::UserPresenter, '#product_status_labels' do
  let!(:organization) { FactoryGirl.create(:organization) }
  let!(:product) { FactoryGirl.create(:product, organization: organization, name: 'Gold')}
  let!(:product2) { FactoryGirl.create(:product, organization: organization, name: 'Silver')}
  let!(:product3) { FactoryGirl.create(:product, organization: organization, name: 'Platinum')}
  let!(:plan) { FactoryGirl.create(:plan, organization: organization, product: product)}
  let!(:plan2) { FactoryGirl.create(:plan, organization: organization, product: product2)}
  let!(:user) { FactoryGirl.create(:user, organization: organization) }
  let!(:active_subscription) { FactoryGirl.create(:subscription, :active, plan: plan, user: user)}
  let!(:canceling_subscription) { FactoryGirl.create(:subscription, :canceling, plan: plan2, user: user)}
  let(:user_presenter) { Organization::UserPresenter.new(user)}

  subject { user_presenter.product_status_labels }


  it 'returns the correct HTML' do
    expect(subject).to eq("<span class=\"label label-success\">GOLD</span><span class=\"label label-warning\">SILVER</span><span class=\"label label-default\">PLATINUM</span>")
  end

end