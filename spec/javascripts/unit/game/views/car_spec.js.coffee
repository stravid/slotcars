
#= require game/views/car

describe 'game.views.CarView (unit)', ->

  CarView = game.views.CarView

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarView).toBe true
    
  it 'should use a default width and height when created if none is given', ->
    mediatorStub = Ember.Object.create
      position:
        x: 0
        y: 0
    
    carView = CarView.create
      mediator: mediatorStub
      paper: 
        rect: ->
        
    (expect carView.get 'width').toNotBe undefined
    (expect carView.get 'height').toNotBe undefined
    