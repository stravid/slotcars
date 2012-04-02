Slotcars::Application.routes.draw do

  devise_for :users

  root :to => 'slotcars#index'

  get '/tracks' => 'slotcars#index'
  get '/build' => 'slotcars#index'
  get '/play/:id' => 'slotcars#index'

  namespace :api do
    resources :tracks, :only => [:index, :show]
  end

end
