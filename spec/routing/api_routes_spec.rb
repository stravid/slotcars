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

  it "routes POST /api/tracks to api::tracks#create" do
    { :post => "/api/tracks" }.should route_to(
        :controller => "api/tracks",
        :action => "create"
      )
  end
end