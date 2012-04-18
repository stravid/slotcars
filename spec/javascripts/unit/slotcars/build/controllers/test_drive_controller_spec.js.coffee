describe 'test drive controller', ->

  BaseGameController = Slotcars.shared.controllers.BaseGameController
  TestDriveController = Slotcars.build.controllers.TestDriveController
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  it 'should extend BaseGameController', ->
    (expect TestDriveController).toExtend BaseGameController

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager,
      goToState: sinon.spy()

    @testDriveController = TestDriveController.create
      stateManager: @buildScreenStateManagerMock
      track: {}
      car: {}

  afterEach ->
    @buildScreenStateManagerMock.restore()

  describe 'editing track', ->

    it 'should go to editing state', ->
      @testDriveController.onEditTrack()

      (expect @buildScreenStateManagerMock.goToState).toHaveBeenCalledWith 'Editing'