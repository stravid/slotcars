#= require slotcars/route_manager

describe 'routing', ->

  RouteManager = slotcars.RouteManager

  beforeEach ->
    @slotcarsApplicationStub =
      showBuildScreen: sinon.spy()
      showPlayScreen: sinon.spy()
      showTracksScreen: sinon.spy()
      showHomeScreen: sinon.spy()

    @routeManager = RouteManager.create
      delegate: @slotcarsApplicationStub

  it 'should show the build screen on /build', ->
    @routeManager.set 'location', '/build'

    (expect @slotcarsApplicationStub.showBuildScreen).toHaveBeenCalled()

  it 'should show the play screen with the correct id on /play/:id', ->
    @routeManager.set 'location', '/play/42'

    (expect @slotcarsApplicationStub.showPlayScreen).toHaveBeenCalledWith '42'

  it 'should show the tracks screen on /tracks', ->
    @routeManager.set 'location', '/tracks'

    (expect @slotcarsApplicationStub.showTracksScreen).toHaveBeenCalled()

  it 'should show the home screen on /', ->
    @routeManager.set 'location', '/'

    (expect @slotcarsApplicationStub.showHomeScreen).toHaveBeenCalled()