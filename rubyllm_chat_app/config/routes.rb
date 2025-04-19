# typed: false
Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users

  # Root path - directs to the main chat interface
  root "chats#index"

  # Chat resources - index shows list, show displays a chat, create starts a new one
  resources :chats, only: [:index, :show, :create, :destroy] do
    # Nested resource for messages within a specific chat
    # Only need 'create' as messages are added to an existing chat context
    resources :messages, only: [:create], shallow: true # shallow makes message paths like /messages/:id instead of /chats/:chat_id/messages/:id
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
