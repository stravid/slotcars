describe 'PlayScreenNotificationsController', ->

  beforeEach ->
    @currentTrackId = 1
    @playScreenNotificationsController = Play.PlayScreenNotificationsController.create trackId: @currentTrackId

  it 'should fire an event for a new run on the current track', ->
    sinon.stub @playScreenNotificationsController, 'fire'
    run = track_id: @currentTrackId

    @playScreenNotificationsController._onNewRunEvent run

    (expect @playScreenNotificationsController.fire).toHaveBeenCalledWith 'newRunOnCurrentTrack', run

  it 'should not fire an event for other tracks', ->
    sinon.stub @playScreenNotificationsController, 'fire'
    run = track_id: 2

    @playScreenNotificationsController._onNewRunEvent run

    (expect @playScreenNotificationsController.fire).not.toHaveBeenCalled()

  it 'should not fire an event for my own runs', ->
    testUserId = 1

    sinon.stub @playScreenNotificationsController, 'fire'

    Shared.User.current =
      get: -> testUserId

    run = 
      track_id: 1
      user_id: testUserId

    @playScreenNotificationsController._onNewRunEvent run

    (expect @playScreenNotificationsController.fire).not.toHaveBeenCalled()