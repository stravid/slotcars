describe 'PlayScreenNotificationsController', ->

  beforeEach ->
    @PlayScreenNotificationsController = Play.PlayScreenNotificationsController.create trackId: 1

  it 'should fire an event for a new run on the current track', ->
    sinon.stub @PlayScreenNotificationsController, 'fire'
    run = track_id: 1

    @PlayScreenNotificationsController._onNewRunEvent run

    (expect @PlayScreenNotificationsController.fire).toHaveBeenCalledWith 'newRunOnCurrentTrack', run

  it 'should not fire an event for other tracks', ->
    sinon.stub @PlayScreenNotificationsController, 'fire'
    run = track_id: 2

    @PlayScreenNotificationsController._onNewRunEvent run

    (expect @PlayScreenNotificationsController.fire).not.toHaveBeenCalled()