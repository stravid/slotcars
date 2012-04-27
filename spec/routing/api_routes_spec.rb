describe "Tracks" do
  it "routes GET /api/tracks to api::tracks#index" do
    { :get => "/api/tracks" }.should route_to(
        :controller => "api/tracks",
        :action => "index"
      )
  end

  it "routes GET /api/tracks/:id to api::tracks#show with params" do
    { :get => "/api/tracks/1" }.should route_to(
        :controller => "api/tracks",
        :action => "show",
        :id => "1"
      )
  end

  it "routes POST /api/tracks to api::tracks#create" do
    { :post => "/api/tracks" }.should route_to(
        :controller => "api/tracks",
        :action => "create"
      )
  end

  it "routes GET /api/tracks/:id/highscores to api::tracks#highscores" do
    { :get => "/api/tracks/1/highscores" }.should route_to(
        :controller => "api/tracks",
        :action => "highscores",
        :id => "1"
      )
  end

end

describe "Users" do

  it "routes POST /api/users to devise::registrations#create" do
      { :post => "api/users" }.should route_to(
          :controller => "devise/registrations",
          :action => "create"
        )
  end

end

describe "Sessions" do

  it "routes POST /api/sign_in to api::sessions#create" do
    { :post => "api/sign_in" }.should route_to(
        :controller => "api/sessions",
        :action => "create"
      )
  end

  it "routes delete /api/sign_out to api::sessions#destroy" do
    { :delete => "api/sign_out" }.should route_to(
        :controller => "api/sessions",
        :action => "destroy"
      )
  end
end

describe "Runs" do

  it "routes POST /api/runs to api::runs#create" do
    { :post => "api/runs" }.should route_to(
        :controller => "api/runs",
        :action => "create"
      )
  end

end