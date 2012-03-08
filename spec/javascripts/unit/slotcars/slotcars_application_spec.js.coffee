#= require slotcars/slotcars_application
#= require slotcars/route_manager

describe 'slotcars application screen management', ->

  SlotcarsApplication = slotcars.SlotcarsApplication

  describe 'interaction with screens', ->

    beforeEach ->
      @buildScreenAppendToApplicationSpy = sinon.spy()
      @playScreenAppendToApplicationSpy = sinon.spy()
      @tracksScreenAppendToApplicationSpy = sinon.spy()
      @homeScreenAppendToApplicationSpy = sinon.spy()

      @screenFactoryStub =

        getBuildScreen: sinon.stub().returns
          appendToApplication: @buildScreenAppendToApplicationSpy

        getPlayScreen: sinon.stub().withArgs('42').returns
          appendToApplication: @playScreenAppendToApplicationSpy

        getTracksScreen: sinon.stub().returns
          appendToApplication: @tracksScreenAppendToApplicationSpy

        getHomeScreen: sinon.stub().returns
          appendToApplication: @homeScreenAppendToApplicationSpy

      @slotcarsApplication = SlotcarsApplication.create
        screenFactory: @screenFactoryStub

    afterEach ->
      @slotcarsApplication.destroy()


    it 'should get the BuildScreen and tell it to append', ->
      @slotcarsApplication.showBuildScreen()

      (expect @buildScreenAppendToApplicationSpy).toHaveBeenCalled()

    it 'should get the PlayScreen and tell it to append', ->
      @slotcarsApplication.showPlayScreen 42

      (expect @playScreenAppendToApplicationSpy).toHaveBeenCalled()

    it 'should get the TracksScreen and tell it to append', ->
      @slotcarsApplication.showTracksScreen()

      (expect @tracksScreenAppendToApplicationSpy).toHaveBeenCalled()

    it 'should get the HomeScreen and tell it to append', ->
      @slotcarsApplication.showHomeScreen()

      (expect @homeScreenAppendToApplicationSpy).toHaveBeenCalled()

    it 'should call the destroy method on the old screen when the screens get switched', ->
      homeScreenAppendToApplicationSpy = sinon.spy()
      homeScreenDestroySpy = sinon.spy()

      @screenFactoryStub.getHomeScreen = sinon.stub().returns
        appendToApplication: homeScreenAppendToApplicationSpy
        destroy: homeScreenDestroySpy

      @slotcarsApplication.showHomeScreen()
      @slotcarsApplication.showBuildScreen()

      (expect homeScreenDestroySpy).toHaveBeenCalled()


  describe 'integration with the route manager', ->

    beforeEach ->
      @RouteManagerCreateStub = (sinon.stub slotcars.RouteManager, 'create')

    afterEach ->
      @RouteManagerCreateStub.restore()

    it 'should create route manager and register itself as delegate', ->
      @slotcarsApplication = SlotcarsApplication.create()

      (expect @RouteManagerCreateStub).toHaveBeenCalledWithAnObjectLike
        delegate: @slotcarsApplication
