#= require slotcars/slotcars_application

describe 'screen managment', ->

  SlotcarsApplication = slotcars.SlotcarsApplication

  beforeEach ->
    @screenFactoryStub = {}

    @slotcarsApplication = SlotcarsApplication.create
      screenFactory: @screenFactoryStub

  it 'should get the BuildScreen and tell it to append', ->
    buildScreenAppendToApplicationSpy = sinon.spy()
    @screenFactoryStub.getBuildScreen = sinon.stub().returns
      appendToApplication: buildScreenAppendToApplicationSpy

    @slotcarsApplication.showBuildScreen()

    (expect buildScreenAppendToApplicationSpy).toHaveBeenCalled()

  it 'should get the PlayScreen and tell it to append', ->
    playScreenAppendToApplicationSpy = sinon.spy()
    @screenFactoryStub.getPlayScreen = sinon.stub().withArgs('42').returns
      appendToApplication: playScreenAppendToApplicationSpy

    @slotcarsApplication.showPlayScreen 42

    (expect playScreenAppendToApplicationSpy).toHaveBeenCalled()

  it 'should get the TracksScreen and tell it to append', ->
    tracksScreenAppendToApplicationSpy = sinon.spy()
    @screenFactoryStub.getTracksScreen = sinon.stub().returns
      appendToApplication: tracksScreenAppendToApplicationSpy

    @slotcarsApplication.showTracksScreen()

    (expect tracksScreenAppendToApplicationSpy).toHaveBeenCalled()

  it 'should get the HomeScreen and tell it to append', ->
    homeScreenAppendToApplicationSpy = sinon.spy()
    @screenFactoryStub.getHomeScreen = sinon.stub().returns
      appendToApplication: homeScreenAppendToApplicationSpy

    @slotcarsApplication.showHomeScreen()

    (expect homeScreenAppendToApplicationSpy).toHaveBeenCalled()    

  it 'should call the destroy method on the old screen when the screens get switched', ->
    homeScreenAppendToApplicationSpy = sinon.spy()
    homeScreenDestroySpy = sinon.spy()
    @screenFactoryStub.getHomeScreen = sinon.stub().returns
      appendToApplication: homeScreenAppendToApplicationSpy
      destroy: homeScreenDestroySpy

    buildScreenAppendToApplicationSpy = sinon.spy()
    @screenFactoryStub.getBuildScreen = sinon.stub().returns
      appendToApplication: buildScreenAppendToApplicationSpy

    @slotcarsApplication.showHomeScreen()
    @slotcarsApplication.showBuildScreen()

    (expect homeScreenDestroySpy).toHaveBeenCalled()
