
#= require helpers/namespace

#= require slotcars/play/controllers/game_controller

#= require slotcars/play/views/car_view
#= require slotcars/shared/views/track_view
#= require slotcars/play/views/game_view

namespace 'game'

TrackModel = slotcars.shared.models.TrackModel

game.GameApplication = Ember.View.extend

  elementId: 'game-application'

  trackView: null
  carView: null

  gameView: null
  gameController: null

  paper: null

  didInsertElement: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupGame()

    @gameController.start()

  _setupRaphael: ->
    # @paper = Raphael @$()[0], 1024, 650

  _setupTrack: ->
    # @trackView = slotcars.shared.views.TrackView.create

  _setupGame: ->
    # currentTrackMediator = shared.mediators.currentTrackMediator

    # @gameController = slotcars.play.controllers.GameController.create
    #   track: currentTrackMediator.currentTrack

    # @gameView = slotcars.play.views.GameView.create
    #   gameController: @gameController

    # @gameView.appendTo @$()
