describe 'controllable', ->

  beforeEach ->
    @gameControllerMock = mockEmberClass Shared.BaseGameController,
      onTouchMouseDown: sinon.spy()
      onTouchMouseUp: sinon.spy()
      onKeyDown: sinon.spy()
      onKeyUp: sinon.spy()

    @controllable = Ember.View.extend(Shared.Controllable).create
      gameController: @gameControllerMock

  afterEach ->
    @gameControllerMock.restore()

  describe '#didInsertElement', ->
    beforeEach ->
      sinon.stub @controllable, 'setupTouchListeners'
      sinon.stub @controllable, 'setupKeyListeners'

      @controllable.didInsertElement()

    it 'calls #setupTouchListeners', ->
      (expect @controllable.setupTouchListeners).toHaveBeenCalled()

    it 'calls #setupKeyListeners', ->
      (expect @controllable.setupKeyListeners).toHaveBeenCalled()

  describe '#willDestroyElement', ->
    beforeEach ->
      sinon.stub @controllable, 'removeTouchListeners'
      sinon.stub @controllable, 'removeKeyListeners'

      @controllable.willDestroyElement()

    it 'calls #removeTouchListeners', ->
      (expect @controllable.removeTouchListeners).toHaveBeenCalled()

    it 'calls #removeKeyListeners', ->
      (expect @controllable.removeKeyListeners).toHaveBeenCalled()

  describe '#setupTouchListeners', ->
    beforeEach ->
      Ember.run => @controllable.appendTo jQuery '<div>'

      @controllable.setupTouchListeners()

    it 'binds gameController#onTouchMouseDown to the elements touchMouseDown event', ->
      (jQuery @controllable.$()).trigger 'touchMouseDown'

      (expect @gameControllerMock.onTouchMouseDown).toHaveBeenCalled()

    it 'binds gameController#onTouchMouseUp to the documents touchMouseUp event', ->
      (jQuery document).trigger 'touchMouseUp'

      (expect @gameControllerMock.onTouchMouseUp).toHaveBeenCalled()

  describe '#setupKeyListeners', ->
    beforeEach ->
      Ember.run => @controllable.appendTo jQuery '<div>'

      @controllable.setupKeyListeners()

    it 'binds gameController#onKeyDown to the documents keydown event', ->
      (jQuery document).trigger 'keydown'

      (expect @gameControllerMock.onKeyDown).toHaveBeenCalled()

    it 'binds gameController#onKeyUp to the documents keyup event', ->
      (jQuery document).trigger 'keyup'

      (expect @gameControllerMock.onKeyUp).toHaveBeenCalled()

  describe '#removeTouchListeners', ->
    beforeEach ->
      Ember.run => @controllable.appendTo jQuery '<div>'

      @controllable.setupTouchListeners()
      @controllable.removeTouchListeners()

    it 'unbinds the touchMouseDown event', ->
      (jQuery @controllable.$()).trigger 'touchMouseDown'

      (expect @gameControllerMock.onTouchMouseDown).not.toHaveBeenCalled()

    it 'unbinds the touchMouseUp event', ->
      (jQuery document).trigger 'touchMouseUp'

      (expect @gameControllerMock.onTouchMouseUp).not.toHaveBeenCalled()

  describe '#removeKeyListeners', ->
    beforeEach ->
      Ember.run => @controllable.appendTo jQuery '<div>'

      @controllable.setupKeyListeners()
      @controllable.removeKeyListeners()

    it 'unbinds the keydown event', ->
      (jQuery document).trigger 'keydown'

      (expect @gameControllerMock.onKeyDown).not.toHaveBeenCalled()

    it 'unbinds the keyup event', ->
      (jQuery document).trigger 'keyup'

      (expect @gameControllerMock.onKeyUp).not.toHaveBeenCalled()
