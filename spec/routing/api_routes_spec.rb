describe "Tracks" do
  it "routes /api/tracks to api::tracks#index" do
    { :get => "/api/tracks" }.should route_to(
      :controller => "api/tracks",
      :action => "index"
    )
  end
end