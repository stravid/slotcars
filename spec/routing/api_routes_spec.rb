describe "Tracks" do
  it "routes /api/tracks to api::tracks#index" do
    { :get => "/api/tracks" }.should route_to(
        :controller => "api/tracks",
        :action => "index"
      )
  end

  it "routes /api/tracks/:id to api::tracks#show with params" do
    { :get => "/api/tracks/1" }.should route_to(
        :controller => "api/tracks",
        :action => "show",
        :id => "1"
      )
  end
end

describe "Users" do

  it "routes post /api/users to devise::registrations#create" do
      { :post => "api/users" }.should route_to(
          :controller => "devise/registrations",
          :action => "create"
        )
  end

end