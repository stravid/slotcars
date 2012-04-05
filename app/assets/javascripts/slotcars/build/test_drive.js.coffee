
#= require slotcars/shared/controllers/base_game_controller
#= require slotcars/play/views/car_view
#= require slotcars/play/views/play_track_view

BaseGameController = Slotcars.shared.controllers.BaseGameController
CarView = slotcars.play.views.CarView
TestTrackView = slotcars.play.views.PlayTrackView

(namespace 'Slotcars.build').TestDrive = Ember.Object.extend

  buildScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = BaseGameController.create track: @track, car: @car

    @_carView = CarView.create car: @car
    @_trackView = TestTrackView.create 
      track: @track
      gameController: @_gameController

    @buildScreenView.set 'contentView', @_trackView
    @buildScreenView.set 'carView', @_carView

  start: ->
    @_gameController.start()

  destroy: ->
    @_gameController.destroy()
