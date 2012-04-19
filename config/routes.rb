Slotcars::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => 'api/sessions' }

  root :to => 'slotcars#index'

  get '/tracks' => 'slotcars#index'
  get '/build' => 'slotcars#index'
  get '/play/:id' => 'slotcars#index'

  namespace :api do
    resources :tracks, :only => [:index, :show]
  end

  devise_scope :user do
    root :to => "devise/sessions#new", :as => :users
    post 'api/users', :to => "devise/registrations#create"
    post 'api/sign_in', :to => "api/sessions#create"
  end

end
