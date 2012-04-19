describe 'test drive view', ->

  beforeEach ->
    @testDriveController = mockEmberClass Build.TestDriveController,
      onEditTrack: sinon.spy()

    @testDriveView = Build.TestDriveView.create
      track: {}
      testDriveController: @testDriveController

  afterEach ->
    @testDriveController.restore()

  it 'should extend Ember.View', ->
    (expect Build.TestDriveView).toExtend Ember.View

  describe 'editing the track', ->

    it 'should tell the controller when user clicked the edit button', ->
      @testDriveView.onEditTrackButtonClicked()

      (expect @testDriveController.onEditTrack).toHaveBeenCalled()
