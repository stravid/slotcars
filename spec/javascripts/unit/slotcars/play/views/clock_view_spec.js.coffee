describe 'Play.ClockView (unit)', ->
  
  beforeEach ->
    @gameController = Play.GameController.create
      track: Ember.Object.create()  # real track is not necessary here
      car: Ember.Object.create()
    
    @trackModel = Shared.ModelStore.findByClientId Shared.Track, 0
    @carModel = Shared.Car.create
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100
      track: @trackModel

    @clockView = Play.ClockView.create
      gameController: @gameController
      carModel: @carModel
      trackModel: @trackModel
  
  it 'should extend Ember.View', ->
    (expect Play.ClockView).toExtend Ember.View
      
  it 'should call updateTime when raceTime changes in GameController', ->
    @clockView.updateTime = sinon.spy()
    @gameController.set 'raceTime', 28
    (expect @clockView.updateTime).toHaveBeenCalledWith 28
    
  it 'should call updateLap when currentLap changes in Car', ->
    @clockView.updateLap = sinon.spy()
    @carModel.set 'currentLap', 2
    (expect @clockView.updateLap).toHaveBeenCalledWith 2
    
    
    
