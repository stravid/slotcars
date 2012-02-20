
#= require game/controllers/car_controller

describe 'game.controllers.CarController', ->

  CarController = game.controllers.CarController

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarController).toBe true

  describe 'defaults on creation', ->

    beforeEach ->
      @car = CarController.create()

    it 'should set speed to zero', ->
      (expect @car.speed).toBe 0

    it 'should set lengthAtTrack', ->
      (expect @car.lengthAtTrack).toBe 0


  describe '#setTrackPath', ->

    beforeEach ->
      @path = "M10,20L30,40"
      @car = CarController.create
        trackPath: @path
        lengthAtTrack: 5

    it 'should reset lengthAtTrack to zero', ->
      @car.setTrackPath @path

      (expect @car.lengthAtTrack).toBe 0
