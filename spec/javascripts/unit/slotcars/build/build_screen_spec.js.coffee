
#= require slotcars/build/build_screen

describe 'build screen', ->

  BuildScreen = slotcars.build.BuildScreen

  beforeEach ->
    @BuildScreenStateManagerCreateStub = (sinon.stub slotcars.build.BuildScreenStateManager, 'create')

  afterEach -> @BuildScreenStateManagerCreateStub.restore()

  it 'should mark itself as buildScreen for duck typing', ->
    buildScreen = BuildScreen.create()

    (expect buildScreen.isBuildScreen).toBe true

  describe 'integration with build screen state manager', ->

    it 'should create state manager and register as delegate', ->
      buildScreen = BuildScreen.create()
      (expect @BuildScreenStateManagerCreateStub).toHaveBeenCalledWithAnObjectLike delegate: buildScreen