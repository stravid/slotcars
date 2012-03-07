Slotcars::Application.routes.draw do

  root :to => 'tracks#index'

  get '/tracks/:id' => 'tracks#index'
  get '/build' => 'tracks#index'

end
