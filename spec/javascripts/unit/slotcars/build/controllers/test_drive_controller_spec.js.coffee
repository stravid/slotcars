describe 'test drive controller', ->

  it 'should extend BaseGameController', ->
    (expect Build.TestDriveController).toExtend Shared.BaseGameController

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager,
      goToState: sinon.spy()

    @testDriveController = Build.TestDriveController.create
      stateManager: @buildScreenStateManagerMock
      track: {}
      car: {}

  afterEach ->
    @buildScreenStateManagerMock.restore()

  describe 'editing track', ->

    it 'should go to editing state', ->
      @testDriveController.onEditTrack()

      (expect @buildScreenStateManagerMock.goToState).toHaveBeenCalledWith 'Editing'