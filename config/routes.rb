Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root to: "posts#index"
  resources :posts do
    resources :comments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


end
