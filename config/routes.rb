Rails.application.routes.draw do
  devise_for :organizers, controllers: {passwords: 'organization/passwords', registrations: 'organization/registrations', sessions: 'organization/sessions', invitations: 'organization/invitations'}
  devise_for :users, controllers: {registrations: 'user/registrations', sessions: 'user/sessions', passwords: 'user/passwords', invitations: 'organization/invitations'}

  root 'user/dashboard#show', constraints: { subdomain: /.+/ }

  post 'notifications' => 'notifications#create', constraints: { subdomain: /.+/ }
  
  resources :organizations

  namespace :organization do
    root 'dashboard#show'
    resource :dashboard, controller: 'dashboard', only: [:show]
    resources :invoices
    resources :locations

    resources :organizers do
      post :invite, on: :collection
      put :super_admin_toggle, on: :member
    end

    resources :plans
    resources :products
    
    resource :reports do
      get :direct_shipping
      get :local_pickup
      get :digital_membership
      get :sales_reps
    end

    resources :sales_reps

    resource :settings do
      get :edit_organization_settings
      put :update_organization_settings
      get :edit_application_settings
      put :update_application_settings
    end

    resources :subscriptions do
      post :add, on: :collection
      put :change_plan, on: :member
      put :postpone, on: :member
      get :canceling, on: :member
      put :cancel, on: :member
      put :terminate, on: :member
    end
    resources :transactions

    resources :users do
      resources :credits, only: [:new, :create]
      resources :notes, only: :create
      get :edit_billing_info, on: :member
      put :update_billing_info, on: :member
    end
  end

  namespace :user do
    resource :billing_info, only: [:edit, :update]
    resources :invoices, only: [:show, :index]
    resources :products, only: [:show, :index]
    resources :transactions, only: :index
    resources :subscriptions, only: [:new, :create]
  end
  
end
