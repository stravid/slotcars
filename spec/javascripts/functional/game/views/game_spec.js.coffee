
#= require game/views/game_view
#= require game/mediators/game_mediator

describe 'game.views.GameView (functional)', ->

  GameView = game.views.GameView
  GameMediator = game.mediators.GameMediator    

  it 'should display a div with race time', ->
    gameView = GameView.create
      mediator: GameMediator.create() 

    (expect gameView.container).toContain(gameView.timeContainer)
    (expect gameView.timeContainer).not.toBeEmpty()
  
  it 'should update race time when it changes', ->
    gameMediator = GameMediator.create()
    value = 28
    
    gameView = GameView.create
      body: $ '<div>'
      mediator: gameMediator
    
    gameMediator.set 'raceTime', value
    
    (expect gameView.timeContainer.text()).toBe gameView.formatTime value
  