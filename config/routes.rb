Rails.application.routes.draw do
  devise_for :organizers, controllers: {passwords: 'organization/passwords', registrations: 'organization/registrations', sessions: 'organization/sessions', invitations: 'organization/invitations'}
  devise_for :users, controllers: {registrations: 'user/registrations', sessions: 'user/sessions', passwords: 'user/passwords'}

  resources :organizations

  namespace :organization do
    root 'dashboard#show'
    resource :dashboard, controller: 'dashboard', only: [:show]
    resources :locations

    resource :settings do
      get :edit_organization_settings
      put :update_organization_settings
      get :edit_application_settings
      put :update_application_settings
    end

    resources :products
  end
  
end
