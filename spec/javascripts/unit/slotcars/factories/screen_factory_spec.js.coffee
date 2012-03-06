
#= require slotcars/factories/screen_factory

describe 'screen factory', ->

  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @screenFactory = ScreenFactory.create()

  describe 'getting build screen', ->

    beforeEach ->
      @BuildScreenStateManagerCreateStub = (sinon.stub slotcars.build.BuildScreenStateManager, 'create')

    afterEach ->
      @BuildScreenStateManagerCreateStub.restore()

    it 'should return an instance of the build screen', ->
      buildScreen = @screenFactory.getBuildScreen()

      (expect buildScreen.isBuildScreen).toBe true


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

      (expect tracksScreen.isTracksScreen).toBe true


  describe 'getting home screen', ->

    it 'should return an instance of the home screen', ->
      homeScreen = @screenFactory.getHomeScreen()

      (expect homeScreen.isHomeScreen).toBe true


