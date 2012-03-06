
#= require slotcars/factories/screen_factory
#= require slotcars/build/build_screen
#= require slotcars/tracks/tracks_screen
#= require slotcars/home/home_screen

describe 'screen factory', ->

  ScreenFactory = slotcars.factories.ScreenFactory
  BuildScreen = slotcars.build.BuildScreen
  TracksScreen = slotcars.tracks.TracksScreen
  HomeScreen = slotcars.home.HomeScreen

  beforeEach ->
    @screenFactory = ScreenFactory.create()

  describe 'getting build screen', ->

    it 'should return an instance of the build screen', ->
      buildScreen = @screenFactory.getBuildScreen()

      (expect buildScreen).toBeInstanceOf BuildScreen


  describe 'getting play screen', ->

    beforeEach ->
      @playScreenInstanceStub = {}
      @playScreenCreateStub = (sinon.stub slotcars.play.PlayScreen, 'create')
      @playScreenCreateStub.returns @playScreenInstanceStub

    afterEach ->
      @playScreenCreateStub.restore()

    it 'should return an instance of the play screen and provide id', ->
      playScreen = @screenFactory.getPlayScreen 42

      (expect @playScreenCreateStub).toHaveBeenCalledWithAnObjectLike trackId: 42
      (expect playScreen).toBe @playScreenInstanceStub


  describe 'getting tracks screen', ->

    it 'should return an instance of the tracks screen', ->
      tracksScreen = @screenFactory.getTracksScreen()

      (expect tracksScreen).toBeInstanceOf TracksScreen


  describe 'getting home screen', ->

    it 'should return an instance of the home screen', ->
      homeScreen = @screenFactory.getHomeScreen()

      (expect homeScreen).toBeInstanceOf HomeScreen
