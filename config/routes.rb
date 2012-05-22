Slotcars::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => 'api/sessions' }

  root :to => 'slotcars#index'

  get '/tracks' => 'slotcars#index'
  get '/build' => 'slotcars#index'
  get '/quickplay' => 'slotcars#index'
  get '/play/:id' => 'slotcars#index'
  get '/error' => 'slotcars#index'

  namespace :api do
    resources :tracks, :only => [:index, :show, :create] do
      member do
        get 'highscores'
      end

      collection do
        get 'random'
        get 'count'
      end
    end

    resources :runs, :only => [:create]
    resources :ghosts, :only => [:create, :index]

    resources :users, :only => [] do
      member do
        get 'highscores'
      end
    end
  end

  devise_scope :user do
    root :to => "devise/sessions#new", :as => :users
    post 'api/users', :to => "devise/registrations#create"
    post 'api/sign_in', :to => "api/sessions#create"
    delete 'api/sign_out', :to => "api/sessions#destroy"
  end

end
