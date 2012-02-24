#= require builder/controllers/builder_controller


describe 'builder.controllers.BuilderController (unit)', ->

  BuilderController = builder.controllers.BuilderController

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect BuilderController).toBe true

  describe '#onTouchMouseMove', ->

    beforeEach ->
      @trackMediatorStub =
        points: []

      @builderController = BuilderController.create
        mediator: @trackMediatorStub

    it 'should add a point to the track mediator', ->
      @builderController.onTouchMouseMove
        x: 10
        y: 10

      (expect @trackMediatorStub.points.length).toEqual 1

    # it 'should calculate the correct angle', ->
    #   @builderController.onTouchMouseMove
    #     x: 0
    #     y: 0
    # 
    #   @builderController.onTouchMouseMove
    #     x: 10
    #     y: 10
    # 
    #   @builderController.onTouchMouseMove
    #     x: 10
    #     y: 10
    # 
    #   (expect @trackMediatorStub.points[0].angle).toEqual