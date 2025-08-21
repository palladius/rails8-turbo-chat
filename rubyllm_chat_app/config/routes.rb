# typed: false
Rails.application.routes.draw do
  root "chat_cards#index"
  get "/about", to: "pages#about"
  get "/config", to: "pages#config"
  # Devise routes for authentication
  devise_for :users

  # Chat resources - index shows list, show displays a chat, create starts a new one
#  resources :chats, only: [:index, :show, :create, :destroy] do
  resources :chats, only: [:index, :show, :create, :edit, :update, :destroy] do
    member do
      post 'generate_image'
      delete 'delete_image'
      patch 'regenerate_title'
      patch 'generate_description'
      patch 'im_feeling_lucky'
    end

    # Nested resource for messages within a specific chat
    # Only need 'create' as messages are added to an existing chat context
    resources :messages, only: [:create], shallow: true # shallow makes message paths like /messages/:id instead of /chats/:chat_id/messages/:id
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Route for Cloud Scheduler to trigger the autotitle job
  post '/jobs/autotitle_chats', to: 'jobs#autotitle_chats'
  # GET route for local testing purposes only
  get '/jobs/autotitle_chats', to: 'jobs#autotitle_chats'
end
