describe 'controllable', ->

  beforeEach ->
    @gameControllerMock = mockEmberClass Shared.BaseGameController

    @controllable = Ember.View.extend(Shared.Controllable).create
      gameController: @gameControllerMock

  afterEach ->
    @gameControllerMock.restore()

  describe 'calling to set up touch listeners after inserted into DOM', ->

    beforeEach -> sinon.stub @controllable, 'setupTouchListeners'

    it 'should setup touch listeners on didInsertElement', ->
      @controllable.didInsertElement()

      (expect @controllable.setupTouchListeners).toHaveBeenCalled()


  describe 'setup and remove touch listeners', ->

    beforeEach ->
      @gameControllerMock.onTouchMouseDown = sinon.spy()
      @gameControllerMock.onTouchMouseUp = sinon.spy()
      Ember.run => @controllable.appendTo jQuery '<div>'

    describe 'setting up touch listeners', ->

      it 'should setup onTouchMouseDown listener on element and tell game controller about events', ->
        @controllable.setupTouchListeners()

        (jQuery @controllable.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).toHaveBeenCalled()

      it 'should setup onTouchMouseUp listener on document and tell game controller about events', ->
        @controllable.setupTouchListeners()

        (jQuery document).trigger 'touchMouseUp'

        (expect @gameControllerMock.onTouchMouseUp).toHaveBeenCalled()


    describe 'removing touch listeners on destroy', ->

      beforeEach ->
        @controllable.setupTouchListeners()

      it 'should remove the touch listeners from element', ->
        @controllable.destroy()

        (jQuery @controllable.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).not.toHaveBeenCalled()

      it 'should remove the touch listeners from document', ->
        @controllable.destroy()

        (jQuery document).trigger 'touchMouseUp'

        (expect @gameControllerMock.onTouchMouseUp).not.toHaveBeenCalled()
