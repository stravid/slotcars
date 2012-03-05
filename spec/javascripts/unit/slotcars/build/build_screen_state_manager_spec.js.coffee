
#= require slotcars/build/build_screen_state_manager

describe 'slotcars.build.BuildScreenStateManager', ->

  BuildScreenStateManager = slotcars.build.BuildScreenStateManager

  beforeEach ->
    @buildScreenStub =
      appendScreen: sinon.spy()
      removeScreen: sinon.spy()
      loadTrack: sinon.spy()
      startDrawMode: sinon.spy()
      cleanupDrawMode: sinon.spy()

    @buildScreenStateManager = BuildScreenStateManager.create
      delegate: @buildScreenStub

    @buildScreenStateManager.send 'startBuilding'


  describe 'entering and exiting the building state', ->

    it 'should tell the build screen to append itself to the DOM when entered', ->
      (expect @buildScreenStub.appendScreen).toHaveBeenCalled()

    it 'should tell the build screen to remove itself from the DOM when exited', ->
      @buildScreenStateManager.send 'destroyScreen'

      (expect @buildScreenStub.removeScreen).toHaveBeenCalled()


  describe 'transition from appending to loading', ->

    it 'should activate the loading state when screen was appended', ->
      @buildScreenStateManager.send 'didAppendScreen'

      (expect @buildScreenStub.loadTrack).toHaveBeenCalled()


  describe 'transition from loading the track to drawing mode', ->

    beforeEach ->
      @buildScreenStateManager.send 'didAppendScreen' # go to loading

    it 'should activate drawing mode when building a new track', ->
      @buildScreenStateManager.send 'newTrackCreated'

      (expect @buildScreenStub.startDrawMode).toHaveBeenCalled()


  describe 'cleaning up the drawing mode', ->

    beforeEach ->
      @buildScreenStateManager.send 'didAppendScreen' # go to loading
      @buildScreenStateManager.send 'newTrackCreated' # go to drawing mode

    it 'should tell the build screen to cleanup drawing mode when it gets destroyed', ->
      @buildScreenStateManager.send 'destroyScreen'

      (expect @buildScreenStub.cleanupDrawMode).toHaveBeenCalled()