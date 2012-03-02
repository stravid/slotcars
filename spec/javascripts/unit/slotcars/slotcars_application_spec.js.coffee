#= require slotcars/slotcars_application

describe 'screen managment', ->

  SlotcarsApplication = slotcars.SlotcarsApplication

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
