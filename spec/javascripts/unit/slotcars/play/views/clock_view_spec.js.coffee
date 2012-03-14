
#= require slotcars/play/views/clock_view
#= require slotcars/play/controllers/game_controller

describe 'slotcars.play.views.ClockView (unit)', ->
  
  ClockView = slotcars.play.views.ClockView
  GameController = slotcars.play.controllers.GameController
  
  beforeEach ->
    @gameController = GameController.create
      track: Ember.Object.create()  # real track is not necessary here
      car: Ember.Object.create()

    @clockView = ClockView.create
      gameController: @gameController
  
  it 'should extend Ember.View', ->
    (expect ClockView).toExtend Ember.View
      
  it 'should call updateTime when raceTime changes in GameController', ->
    @clockView.updateTime = sinon.spy()
    
    value = 28
    @gameController.set 'raceTime', 28
    
    (expect @clockView.updateTime).toHaveBeenCalledWith 28
    
