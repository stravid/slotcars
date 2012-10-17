describe 'Shared.RouteManager', ->

  beforeEach ->
    sinon.stub Ember.run, 'later'
    sinon.spy Shared.BrowserSupportable, 'apply'

    @slotcarsApplicationStub =
      showScreen: sinon.spy()
      destroyCurrentScreen: sinon.spy()
      isBrowserSupported: -> true

    @routeManager = Shared.RouteManager.create delegate: @slotcarsApplicationStub
    @routeManager._skipPush = true # prevent changing the url while running the test suite

  afterEach ->
    Ember.run.later.restore()
    Shared.BrowserSupportable.apply.restore()
    @routeManager.destroy()

  it 'should use html5 push state', ->
    (expect @routeManager.get 'wantsHistory').toBe true

  it 'should set correct baseURI for routing', ->
    expectedBaseURI = window.location.origin || ( window.location.protocol + "//" + window.location.host )
    (expect @routeManager.get 'baseURI').toBe expectedBaseURI

  it 'should apply the BrowserSupportable mixin on all valid states', ->
    (expect Shared.BrowserSupportable.apply.callCount).toEqual 6

  it 'should show the build screen on /build', ->
    @routeManager.set 'location', 'build'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'BuildScreen'

  it 'should show the play screen on /quickplay', ->
    @routeManager.set 'location', 'quickplay'
    Ember.run.later.args[0][0].call() # calls the callback immediately - sadly, useFakeTimers doesn´t work

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

  it 'should show the unsupported screen on /unsupported', ->
    @routeManager.set 'location', 'unsupported'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'UnsupportedScreen'

  it 'should show the error screen if location is no valid route', ->
    @routeManager.set 'location', 'some/randomLocation'

    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'ErrorScreen'

  it 'should reload the play screen when receiving message in Quickplay state', ->
    @routeManager.transitionTo 'Quickplay'
    sinon.spy @routeManager, 'transitionTo'

    @routeManager.send 'quickplay'
    Ember.run.later.args[0][0].call() # calls the callback immediately - sadly, useFakeTimers doesn´t work

    (expect @slotcarsApplicationStub.destroyCurrentScreen).toHaveBeenCalled()
    (expect @slotcarsApplicationStub.showScreen).toHaveBeenCalledWith 'PlayScreen'

  it 'should go to Quickplay when receiving message in Play state', ->
    @routeManager.transitionTo 'Play'
    sinon.spy @routeManager, 'transitionTo'

    @routeManager.send 'quickplay'

    (expect @routeManager.transitionTo).toHaveBeenCalledWith 'Quickplay'


describe 'Shared.RouteState', ->

  describe 'leaving the state', ->
    beforeEach ->
      @routeState = Shared.RouteState.create()
      @slotcarsApplicationStub = destroyCurrentScreen: sinon.spy()
      @RouteManagerMock = mockEmberClass Shared.RouteManager,
        delegate: @slotcarsApplicationStub

    afterEach -> @RouteManagerMock.restore()

    it 'should call destroy the current screen', ->
      @routeState.exit @RouteManagerMock

      (expect @slotcarsApplicationStub.destroyCurrentScreen).toHaveBeenCalled()


describe 'Shared.BrowserSupportable', ->

  beforeEach ->
    @slotcarsApplicationStub = isBrowserSupported: sinon.stub()
    @RouteManagerMock = mockEmberClass Shared.RouteManager,
      delegate: @slotcarsApplicationStub
      transitionTo: sinon.spy()

    @stateEnterSpy = sinon.spy()
    @state = Ember.State.create
      enter: (manager) => @stateEnterSpy()

  afterEach -> @RouteManagerMock.restore()

  describe 'on enter', ->

    it 'should check if browser is supported', ->
      Shared.BrowserSupportable.apply @state

      @state.enter @RouteManagerMock

      (expect @slotcarsApplicationStub.isBrowserSupported).toHaveBeenCalled()

    describe 'when browser is supported', ->

      it 'should call the state´s original enter method', ->
        @slotcarsApplicationStub.isBrowserSupported.returns true
        Shared.BrowserSupportable.apply @state

        @state.enter @RouteManagerMock

        (expect @stateEnterSpy).toHaveBeenCalled()

    describe 'when browser is not supported', ->

      beforeEach -> @slotcarsApplicationStub.isBrowserSupported.returns false

      it 'should not call the states original enter method', ->
        Shared.BrowserSupportable.apply @state

        @state.enter @RouteManagerMock

        (expect @stateEnterSpy).not.toHaveBeenCalled()

      it 'should transit to Unsupported state', ->
        Shared.BrowserSupportable.apply @state

        @state.enter @RouteManagerMock

        (expect @RouteManagerMock.transitionTo).toHaveBeenCalledWith 'Unsupported'
