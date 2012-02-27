Slotcars::Application.routes.draw do

  root :to => 'tracks#index'

  get '/tracks/:id' => 'tracks#index'
  get '/tracks/new' => 'tracks#index'

end
