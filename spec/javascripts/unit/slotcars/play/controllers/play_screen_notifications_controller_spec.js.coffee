describe 'PlayScreenNotificationsController', ->

  beforeEach ->
    @currentTrackId = 1
    @PlayScreenNotificationsController = Play.PlayScreenNotificationsController.create trackId: @currentTrackId

  it 'should fire an event for a new run on the current track', ->
    sinon.stub @PlayScreenNotificationsController, 'fire'
    run = track_id: @currentTrackId

    @PlayScreenNotificationsController._onNewRunEvent run

    (expect @PlayScreenNotificationsController.fire).toHaveBeenCalledWith 'newRunOnCurrentTrack', run

  it 'should not fire an event for other tracks', ->
    sinon.stub @PlayScreenNotificationsController, 'fire'
    run = track_id: 2

    @PlayScreenNotificationsController._onNewRunEvent run

    (expect @PlayScreenNotificationsController.fire).not.toHaveBeenCalled()

  it 'should not fire an event for my own runs', ->
    testUserId = 1

    sinon.stub @PlayScreenNotificationsController, 'fire'

    Shared.User.current =
      get: -> testUserId

    run = 
      track_id: 1
      user_id: testUserId

    @PlayScreenNotificationsController._onNewRunEvent run

    (expect @PlayScreenNotificationsController.fire).not.toHaveBeenCalled()