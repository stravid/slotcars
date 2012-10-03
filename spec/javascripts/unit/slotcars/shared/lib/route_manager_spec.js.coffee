describe 'routing', ->

  beforeEach ->
    @slotcarsApplicationStub = showScreen: sinon.spy()
    @routeManager = Shared.RouteManager.create delegate: @slotcarsApplicationStub

  afterEach -> @routeManager.destroy()

  it 'should use html5 push state', ->
    (expect @routeManager.get 'wantsHistory').toBe true

  it 'should set correct baseURI for routing', ->
    expectedBaseURI = window.location.origin || ( window.location.protocol + "//" + window.location.host )
    (expect @routeManager.get 'baseURI').toBe expectedBaseURI

  it 'should show the build screen on /build', ->
    @routeManager.set 'location', 'build'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'BuildScreen'

  it 'should show the play screen', ->
    @routeManager.set 'location', 'quickplay'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'PlayScreen'

  it 'should show the play screen with the correct id on /play/:id', ->
    @routeManager.set 'location', 'play/42'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'PlayScreen', trackId: 42

  it 'should show the tracks screen on /tracks', ->
    @routeManager.set 'location', 'tracks'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'TracksScreen'

  it 'should show the home screen on /', ->
    @routeManager.set 'location', ''

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'HomeScreen'

  it 'should show the error screen on /error', ->
    @routeManager.set 'location', 'error'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'ErrorScreen'

  it 'should show the error screen if location is no valid route', ->
    @routeManager.set 'location', 'some/randomLocation'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'ErrorScreen'
