
#= require game/views/car_view
#= require vendor/raphael

describe 'game.views.CarView (unit)', ->

  CarView = game.views.CarView

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarView).toBe true
    
  it 'should use a default width and height when created if none is given', ->
    carView = CarView.create
      paper: Ember.Object.create
        rect: sinon.stub().returns
          attr: ->
        
    (expect carView.get 'width').toNotBe undefined
    (expect carView.get 'height').toNotBe undefined
    