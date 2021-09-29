Rails.application.routes.draw do
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/404', to: 'errors#not_found', via: :all
  get '/legal', to: 'pages#legal', as: 'legal'
  root to: 'pages#home'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
