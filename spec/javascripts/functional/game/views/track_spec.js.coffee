
#= require game/views/track

describe 'game.views.TrackView (functional)', ->
  
  TrackView = game.views.TrackView
  TrackModel = game.models.TrackModel
  
  beforeEach ->
    @trackPath = 'random path ' + (Math.floor (Math.random 1) * 100) 
    @trackModel = TrackModel._create
      path: @trackPath

    @mediatorStub = Ember.Object.create
      currentTrack: @trackModel

    @paperStub =
      path: sinon.spy()

  it 'should call paper.path when created', ->    
    
    TrackView.create
      mediator: @mediatorStub
      paper: @paperStub
    
    (expect @paperStub.path).toHaveBeenCalledWith @mediatorStub.currentTrack.get 'path'