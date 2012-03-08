Slotcars::Application.routes.draw do

  root :to => 'tracks#index'

  get '/tracks' => 'tracks#index'
  get '/build' => 'tracks#index'
  get '/play/:id' => 'tracks#index'
  get '/tracks' => 'tracks#index'

  namespace :api do
    resources :tracks, :only => [:index]
  end

end
