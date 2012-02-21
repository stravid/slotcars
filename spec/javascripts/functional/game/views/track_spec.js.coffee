
#= require game/views/track

describe 'game.views.TrackView (functional)', ->
  
  TrackView = game.views.TrackView
  
  it 'should call paper.path with mediator.trackPath when created', ->
    mediatorStub = 
      trackPath: "random path " + (Math.floor (Math.random 1) * 100) 
    
    paperStub =
      path: sinon.spy()
    
    TrackView.create
      mediator: mediatorStub
      paper: paperStub
    
    (expect paperStub.path).toHaveBeenCalledWith mediatorStub.trackPath