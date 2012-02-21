
#= require game/controllers/game_application
#= require game/views/track

describe 'game.controllers.GameApplication', ->
  
  GameApplication = game.controllers.GameApplication
  
  it 'should extend Ember.Application', ->
    (expect Ember.Application.detect GameApplication).toBe true

  describe '#create', ->

    beforeEach ->
      @trackMediatorBackup = game.mediators.TrackMediator
      @trackMediatorInstanceStub =
        trackPath: 'M600,200R700,300,400,400,300,200,400,100z'

      @trackMediatorStub = game.mediators.TrackMediator =
        create: sinon.stub().returns @trackMediatorInstanceStub

      @trackViewBackup = game.views.TrackView
      @trackViewStub = game.views.TrackView =
        create: sinon.spy()

      @RaphaelBackup = window.Raphael
      @RaphaelStub = window.Raphael = sinon.stub()
      @RaphaelStub.returns
        raphael: @RaphaelStub

      @carMediatorBackup = game.mediators.CarMediator
      @carMediatorInstanceStub = {}
      @carMediatorStub = game.mediators.CarMediator =
        create: sinon.stub().returns @carMediatorInstanceStub

      @carViewBackup = game.views.CarView
      @carViewStub = game.views.CarView =
        create: sinon.spy()

      @carControllerBackup = game.controllers.CarController

      @carControllerInstanceStub =
        setTrackPath: sinon.spy()

      @carControllerStub = game.controllers.CarController =
        create: sinon.stub().returns @carControllerInstanceStub

    afterEach ->
      game.mediators.TrackMediator = @trackMediatorBackup
      game.views.TrackView = @trackViewBackup

      window.Raphael = @RaphaelBackup

      game.mediators.CarMediator = @carMediatorBackup
      game.views.CarView = @carViewBackup

      game.controllers.CarController = @carControllerBackup

      @application.destroy()

    describe 'setup raphael paper', ->

      it 'should create raphael paper for game as property', ->
        @application = GameApplication.create()
        (expect @RaphaelStub).toHaveBeenCalledWith $(@application.get('rootElement'))[0], 1024, 768
        (expect @application.paper.raphael).toBe @RaphaelStub

    describe 'setup track', ->

      it 'should create track mediator', ->
        @application = GameApplication.create()
        (expect @trackMediatorStub.create).toHaveBeenCalled()

      it 'should create track view and provide mediator', ->
        @application = GameApplication.create()
        (expect @trackViewStub.create).toHaveBeenCalled()
        (expect @trackViewStub.create.args[0][0]['mediator']).toBe @trackMediatorInstanceStub

      it 'should provide raphael paper to track view', ->
        @application = GameApplication.create()
        (expect @trackViewStub.create.args[0][0]['paper'].raphael).toBe @RaphaelStub


    describe 'setup car', ->

      it 'should create car mediator', ->
        @application = GameApplication.create()
        (expect @carMediatorStub.create).toHaveBeenCalled()

      it 'should create car view and provide mediator', ->
        @application = GameApplication.create()
        (expect @carViewStub.create).toHaveBeenCalled()
        (expect @carViewStub.create.args[0][0]['mediator']).toBe @carMediatorInstanceStub

      it 'should provide raphael paper to car view', ->
        @application = GameApplication.create()
        (expect @carViewStub.create.args[0][0]['paper'].raphael).toBe @RaphaelStub

      it 'should create and setup car controller', ->
        @application = GameApplication.create()
        (expect @carControllerStub.create).toHaveBeenCalled()
        (expect @carControllerStub.create.args[0][0]['mediator']).toBe @carMediatorInstanceStub
        (expect @carControllerInstanceStub.setTrackPath).toHaveBeenCalledWith @trackMediatorInstanceStub.trackPath
