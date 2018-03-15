Rails.application.routes.draw do
  # Error handling
  match '/404', to: 'error/errors#not_found', via: :all
  match '/500', to: 'error/errors#internal_server_error', via: :all
  namespace :v1, defaults: {format: 'json'} do
    namespace :auth do
      post 'sign_up', to: 'registrations#create'
    end
  end
end
