Slotcars::Application.routes.draw do

  root :to => 'tracks#index'

  get '/tracks' => 'tracks#index'
  get '/tracks/new' => 'tracks#index'

end
