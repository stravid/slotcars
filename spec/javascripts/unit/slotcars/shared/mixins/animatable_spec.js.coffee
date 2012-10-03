describe 'Shared.Animatable', ->

  beforeEach ->
    @viewStub = Ember.View.create()
    screen =
      view: @viewStub
      append: ->
      set: ->

    @animatable = Shared.Animatable.apply screen

  it 'should always require a view', ->
    # applies the Appendable mixin on an object - assumes an error when 'view' property is not set
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Shared.Animatable.apply Ember.Object.create()).toThrow()

  describe 'appending screen', ->

    it 'should plug-in the animation for the insertion of the view', ->
      didInsertFuncBefore = @viewStub.didInsertElement

      @animatable.append()

      (expect @viewStub.didInsertElement).not.toEqual didInsertFuncBefore

    it 'should call the view´s original didInsertElement method', ->
      didInsertFuncBeforeStub = sinon.stub @viewStub, 'didInsertElement'

      @animatable.append() # overrides 'didInsertElement' of the view

      # calls didInsertElement()
      @viewStub.appendTo '<div>'
      Ember.run.end()

      (expect didInsertFuncBeforeStub).toHaveBeenCalled()

    it 'should call the animation function when the view is inserted into the DOM', ->
      @animatable.animateIn = sinon.spy()

      @animatable.append() # overrides 'didInsertElement' of the view
      @viewStub.didInsertElement()

      (expect @animatable.animateIn).toHaveBeenCalled()

  describe 'animating', ->

    beforeEach ->
      @animationMock = mockEmberClass Shared.Animation, run: sinon.stub()

    afterEach ->
      @animationMock.restore()

    it 'should create a animation and pass required settings', ->
      options = duration: 0, delay: 0
      animationFunction = ->
      callbackFunction = ->

      @animatable.animate options, animationFunction, callbackFunction

      (expect @animationMock.create).toHaveBeenCalledWithAnObjectLike
        options: options
        fn: animationFunction
        callback: callbackFunction

    it 'should run the animation', ->
      @animatable.animate()

      (expect @animationMock.run).toHaveBeenCalled()

  describe 'destroying', ->

    beforeEach ->
      @animatable._super = ->

    describe 'when animation is defined', ->

      beforeEach ->
        @EmberLaterBackup = Ember.run.later
        options = duration: 100, delay: 200
        animationFunction = ->
        callbackFunction = ->

        @animationMock = mockEmberClass Shared.Animation,
          run: sinon.stub().returns { options: options, destroy: -> }

        @animatable.animateOut = -> @animate options, animationFunction, callbackFunction

        sinon.spy @animatable, 'animateOut'
        sinon.spy Ember.run, 'later'

      afterEach ->
        @animationMock.restore()
        Ember.run.later = @EmberLaterBackup

      it 'should run the destroy-animation', ->
        @animatable.destroy()

        (expect @animatable.animateOut).toHaveBeenCalled()

      it 'should continue destroying after the animation is finished ', ->
        @animatable.destroy()

        (expect Ember.run.later).toHaveBeenCalled()
