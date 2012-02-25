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

    it 'should calculate the correct angle', ->
      @builderController.onTouchMouseMove
        x: 0
        y: 0

      @builderController.onTouchMouseMove
        x: 2
        y: 0

      @builderController.onTouchMouseMove
        x: 2
        y: 2

      @builderController.onTouchMouseMove
        x: 1
        y: 1

      (expect @trackMediatorStub.points[0].angle).toBeApproximatelyEqual 135
      (expect @trackMediatorStub.points[1].angle).toBeApproximatelyEqual 90
      (expect @trackMediatorStub.points[2].angle).toBeApproximatelyEqual 135
      (expect @trackMediatorStub.points[3].angle).toBeApproximatelyZeroDegree()