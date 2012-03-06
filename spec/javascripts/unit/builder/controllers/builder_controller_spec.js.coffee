#= require builder/controllers/builder_controller
#= require builder/mediators/builder_mediator
#= require shared/mediators/current_track_mediator
#= require helpers/math/path

describe 'builder.controllers.BuilderController (unit)', ->

  BuilderController = builder.controllers.BuilderController

  it 'should extend Ember.Object', ->
    (expect BuilderController).toExtend Ember.Object

  beforeEach ->
    @builderController = BuilderController.create()

    @points = [
      { x:0, y:0, angle:20}
      { x:10, y:0, angle:20}
    ]

    @cleanStub = sinon.stub @builderController.pointsPath, 'clean'
    @smoothStub = sinon.stub @builderController.pointsPath, 'smooth'
    @asPointArrayStub = (sinon.stub @builderController.pointsPath, 'asPointArray').returns @points

  afterEach ->
    @cleanStub.restore()
    @asPointArrayStub.restore()
    @smoothStub.restore()
    builder.mediators.builderMediator.points = []
    shared.mediators.currentTrackMediator.set 'currentTrack', null


  describe '#onTouchMouseMove', ->

    beforeEach ->
      @pushStub = sinon.stub @builderController.pointsPath, 'push'

    afterEach ->
      @pushStub.restore()

    it 'should add points to path and ask for angle calculation', ->
      point = x: 10, y: 10
      @builderController.onTouchMouseMove point

      (expect @pushStub).toHaveBeenCalledWith point, true


  describe '#onTouchMouseUp', ->

    it 'should clean points', ->
      @builderController.onTouchMouseUp()

      (expect @cleanStub).toHaveBeenCalled()
      (expect @asPointArrayStub).toHaveBeenCalled()
      (expect builder.mediators.builderMediator.points).toBe @points

    it 'should smooth points', ->
      @builderController.onTouchMouseUp()

      (expect @smoothStub).toHaveBeenCalled()


  describe '#resetPath', ->

    beforeEach ->
      @clearStub = sinon.stub @builderController.pointsPath, 'clear'

    afterEach ->
      @clearStub.restore()

    it 'should call reset on pointsPath', ->
      @builderController.resetPath()

      (expect @clearStub).toHaveBeenCalled()
