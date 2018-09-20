# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :twitch_chat_keys
  root 'welcome_page#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/twitch_chat', to: 'twitch_chat_keys#index'
  match '/twitch_chat/enable' => 'twitch_chat_keys#enable', via: :get
end
