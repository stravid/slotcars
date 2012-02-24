
#= require game/views/track

describe 'game.views.TrackView (functional)', ->
  
  TrackView = game.views.TrackView
  TrackModel = game.models.TrackModel
  
  beforeEach ->
    @store = DS.Store.create()
    @trackPath = 'random path ' + (Math.floor (Math.random 1) * 100) 
    @trackModel = @store.createRecord TrackModel,
      path: @trackPath

    @mediatorStub = Ember.Object.create
      currentTrack: @store.find TrackModel, 1

    @paperStub =
      path: sinon.spy()

  it 'should call paper.path when created', ->    
    
    TrackView.create
      mediator: @mediatorStub
      paper: @paperStub
    
    (expect @paperStub.path).toHaveBeenCalledWith @mediatorStub.currentTrack.get 'path'