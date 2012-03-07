
#= require helpers/namespace

#= require game/controllers/game_controller

#= require game/views/car_view
#= require game/views/track_view
#= require game/views/game_view

namespace 'game'

TrackModel = shared.models.TrackModel

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
    @paper = Raphael @$()[0], 1024, 650

  _setupTrack: ->
    @trackView = game.views.TrackView.create
      paper: @paper

  _setupGame: ->
    currentTrackMediator = shared.mediators.currentTrackMediator

    @gameController = game.controllers.GameController.create
      track: currentTrackMediator.currentTrack

    @gameView = game.views.GameView.create
      gameController: @gameController

    @gameView.appendTo @$()
