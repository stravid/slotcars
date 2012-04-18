describe 'test drive view', ->

  TestDriveView = Slotcars.build.views.TestDriveView
  TestDriveController = Slotcars.build.controllers.TestDriveController
  Track = slotcars.shared.models.Track

  beforeEach ->
    @testDriveController = mockEmberClass TestDriveController,
      onEditTrack: sinon.spy()

    @testDriveView = TestDriveView.create
      track: {}
      testDriveController: @testDriveController

  afterEach ->
    @testDriveController.restore()

  it 'should extend Ember.View', ->
    (expect TestDriveView).toExtend Ember.View

  describe 'editing the track', ->

    it 'should tell the controller when user clicked the edit button', ->
      @testDriveView.onEditTrackButtonClicked()

      (expect @testDriveController.onEditTrack).toHaveBeenCalled()
