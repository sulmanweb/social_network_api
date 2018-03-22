Rails.application.routes.draw do
  # Error handling
  match '/404', to: 'error/errors#not_found', via: :all
  match '/500', to: 'error/errors#internal_server_error', via: :all
  get '/api-docs/v1' => redirect('/dist/index.html?url=/apidocs/apidocs_v1.json')
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
    resources :posts, only: %i[create update destroy]
    resources :users, only: %i[index] do
      member do
        put :request_friend
        put :accept_friend
      end
      collection do
        get :friends
        get :pending_friends
        get :requested_friends
      end
    end
    get '/users/:user_id/posts', to: 'posts#user_posts', as: :user_posts
  end
end