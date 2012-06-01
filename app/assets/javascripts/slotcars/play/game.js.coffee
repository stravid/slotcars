#= require slotcars/shared/lib/base_game

Play.Game = Shared.BaseGame.extend

  # override method of Shared.BaseGame
  _createGameController: ->
    @_gameController = Play.GameController.create
      track: @track
      car: @car

    Shared.Recordable.apply @_gameController

  _createViews: ->
    @_super()

    @_clockView = Play.ClockView.create
      gameController: @_gameController
      car: @car
      track: @track

    @_gameView = Play.GameView.create
      gameController: @_gameController

    @_ghostView = Play.GhostView.create()
    @_gameController.ghostView = @_ghostView


  _applyMixins: ->
    @_super()
    Play.Finishable.apply @_trackView

  _appendViews: ->
    @_super()
    @_baseGameViewContainer.set 'clockView', @_clockView
    @_baseGameViewContainer.set 'gameView', @_gameView
    @_baseGameViewContainer.set 'ghostView', @_ghostView

  destroy: ->
    @_super()
    @_gameView.destroy()
    @_clockView.destroy()
