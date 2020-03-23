Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root :to => "chats#index"

  get 'chats/new_message', to: 'chats#new_message'
  get 'chats/check_message', to: 'chats#check_message'
  get 'chats/check_for_instances', to: 'chats#check_for_instances'

  get 'chats/connect_to_new_user', to: 'chats#connect_to_new_user'
  get 'chats/disconnect_from_current_user', to: 'chats#disconnect_from_current_user'

  get 'admin/index', to: 'admin#index'



end
