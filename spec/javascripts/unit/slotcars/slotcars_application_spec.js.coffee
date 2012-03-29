
#= require slotcars/slotcars_application
#= require slotcars/route_manager
#= require slotcars/factories/screen_factory

describe 'slotcars application screen management', ->

  SlotcarsApplication = slotcars.SlotcarsApplication
  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @RouteManagerCreateStub = mockEmberClass slotcars.RouteManager

  afterEach ->
    @RouteManagerCreateStub.restore()

  describe 'interaction with screens', ->

    beforeEach ->
      @screenMock = appendToApplication: sinon.spy()
      @screenFactoryMock = getInstanceOf: sinon.stub().returns @screenMock

      (sinon.stub ScreenFactory, 'get').returns @screenFactoryMock

      @slotcarsApplication = SlotcarsApplication.create()

    afterEach ->
      @slotcarsApplication.destroy()
      ScreenFactory.get.restore()


    it 'should get the BuildScreen and tell it to append', ->
      @slotcarsApplication.showBuildScreen()

      (expect @screenFactoryMock.getInstanceOf).toHaveBeenCalledWith 'BuildScreen'
      (expect @screenMock.appendToApplication).toHaveBeenCalled()

    it 'should get the PlayScreen and tell it to append', ->
      randomId = Math.round(Math.random() * 100) + 1
      @slotcarsApplication.showPlayScreen randomId

      (expect @screenFactoryMock.getInstanceOf).toHaveBeenCalledWith 'PlayScreen', trackId: randomId
      (expect @screenMock.appendToApplication).toHaveBeenCalled()

    it 'should get the TracksScreen and tell it to append', ->
      @slotcarsApplication.showTracksScreen()

      (expect @screenFactoryMock.getInstanceOf).toHaveBeenCalledWith 'TracksScreen'
      (expect @screenMock.appendToApplication).toHaveBeenCalled()

    it 'should get the HomeScreen and tell it to append', ->
      @slotcarsApplication.showHomeScreen()

      (expect @screenFactoryMock.getInstanceOf).toHaveBeenCalledWith 'HomeScreen'
      (expect @screenMock.appendToApplication).toHaveBeenCalled()

    it 'should call the destroy method on the old screen when the screens get switched', ->
      @homeScreenMock = appendToApplication: sinon.spy(), destroy: sinon.spy()
      (@screenFactoryMock.getInstanceOf.withArgs 'HomeScreen').returns @homeScreenMock

      @slotcarsApplication.showHomeScreen()
      @slotcarsApplication.showBuildScreen()

      (expect @homeScreenMock.destroy).toHaveBeenCalled()


  describe 'integration with the route manager', ->

    beforeEach ->
      @slotcarsApplication = SlotcarsApplication.create()

    afterEach ->
      @slotcarsApplication.destroy()

    it 'should create route manager and register itself as delegate', ->
      (expect @RouteManagerCreateStub.create).toHaveBeenCalledWithAnObjectLike
        delegate: @slotcarsApplication

    it 'should make the route manager a singleton that can be directly accessed', ->
      (expect slotcars.routeManager).toBe @RouteManagerCreateStub
