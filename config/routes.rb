Rails.application.routes.draw do
  # Error handling
  match '/404', to: 'error/errors#not_found', via: :all
  match '/500', to: 'error/errors#internal_server_error', via: :all
  namespace :v1, defaults: {format: 'json'} do
    namespace :auth do
      post 'sign_up', to: 'registrations#create'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
      delete 'destroy', to: 'registrations#destroy'
      get 'confirm_email', to: 'confirmations#confirm'
      post 'reset_password', to: 'passwords#create'
      get 'update_reset', to: 'passwords#update'
      put 'change_password', to: 'passwords#change_password'
    end
  end
end