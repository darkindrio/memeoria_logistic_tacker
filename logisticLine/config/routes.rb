Rails.application.routes.draw do
  get 'users/index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :line
  resources :stages
  resource :states
  resource :containers
  get '/users/show/', to: 'users#show', as: 'show_user_info'
  get '/users/data/', to: 'users#data', as: 'line_data'
  post '/state/next_state/:state_id', to: 'states#next_state', as: 'next_state'
  get '/admin/:user_id', to: 'users#edit', as: 'edit_user_as_admin'
  patch '/admin/update/:user_id', to: 'users#update', as: 'update_user_as_admin'
  get '/users/subscribe/:user_id/:container_id', to: 'users#subscribeAlert', as: 'user_subscribe'
  post '/containers/add_user', to: 'containers#AddUser', as: 'add_user_to_container'
  post '/containers/remove_user', to: 'containers#RemoveUser', as: 'remove_user_to_container'
end
