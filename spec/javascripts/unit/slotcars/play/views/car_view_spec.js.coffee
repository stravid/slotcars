
#= require slotcars/play/views/car_view
#= require vendor/raphael

describe 'slotcars.play.views.CarView (unit)', ->

  CarView = slotcars.play.views.CarView

  it 'should extend Ember.Object', ->
    (expect CarView).toExtend Ember.Object

  it 'should use a default width and height when created if none is given', ->
    carView = CarView.create
      paper: Ember.Object.create
        rect: sinon.stub().returns
          attr: ->

    (expect carView.get 'width').toNotBe undefined
    (expect carView.get 'height').toNotBe undefined
