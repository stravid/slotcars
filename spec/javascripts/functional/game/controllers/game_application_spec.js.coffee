
#= require game/controllers/game_application
#= require game/views/track

describe 'game.controllers.GameApplication', ->
  
  GameApplication = game.controllers.GameApplication
  
  it 'should extend Ember.Application', ->
    (expect Ember.Application.detect GameApplication).toBe true
  
  describe '#ready', ->
    
    beforeEach ->
      @mediatorBackup = game.mediators.TrackMediator
      @mediatorInstanceStub = {}
      @trackMediatorStub = game.mediators.TrackMediator =
        create: sinon.stub().returns @mediatorInstanceStub
        
      @trackViewBackup = game.views.TrackView
      @trackViewStub = game.views.TrackView =
        create: sinon.spy()
        
      @RaphaelBackup = window.Raphael
      @RaphaelStub = window.Raphael = sinon.stub()
      @RaphaelStub.returns
        raphael: @RaphaelStub
        
      @application = GameApplication.create()
      
    afterEach ->
      game.mediators.TrackMediator = @mediatorBackup
      game.views.TrackView = @trackViewBackup
      window.Raphael = @RaphaelBackup
      @application.destroy()  
    
    it 'should create track mediator', ->  
      (expect @trackMediatorStub.create).toHaveBeenCalled()
      
    it 'should create track view and provide mediator', ->
      (expect @trackViewStub.create).toHaveBeenCalled()
      (expect @trackViewStub.create.args[0][0]['mediator']).toBe @mediatorInstanceStub
      
    it 'should provide raphael paper to track view', ->
      (expect @RaphaelStub).toHaveBeenCalledWith $(@application.get('rootElement'))[0], 1024, 768        
      (expect @trackViewStub.create.args[0][0]['paper'].raphael).toBe @RaphaelStub
      
      