
#= require slotcars/shared/controllers/base_game_controller
#= require slotcars/play/views/car_view
#= require slotcars/shared/views/track_view
#= require slotcars/shared/lib/controllable


BaseGameController = Slotcars.shared.controllers.BaseGameController
CarView = slotcars.play.views.CarView
TrackView = slotcars.shared.views.TrackView
Controllable = Slotcars.shared.lib.Controllable

(namespace 'Slotcars.build').TestDrive = Ember.Object.extend

  buildScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = BaseGameController.create track: @track, car: @car

    @_carView = CarView.create car: @car
    @_trackView = TrackView.create
      track: @track
      gameController: @_gameController

    Controllable.apply @_trackView # this line is untested - don´t know how to do it

    @buildScreenView.set 'contentView', @_trackView
    @buildScreenView.set 'carView', @_carView

  start: ->
    @_gameController.start()

  destroy: ->
    @_gameController.destroy()
