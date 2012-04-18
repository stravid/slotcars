describe 'controllable', ->

  Controllable = Slotcars.shared.lib.Controllable
  BaseGameController = Slotcars.shared.controllers.BaseGameController

  beforeEach ->
    @gameControllerMock = mockEmberClass BaseGameController

    @controllable = Ember.View.extend(Controllable).create
      gameController: @gameControllerMock

    @controllable.appendTo '<div>'
    Ember.run.end()

  afterEach ->
    @gameControllerMock.restore()

  describe 'bind/unbind car controls', ->

    beforeEach ->
      @gameControllerMock.onTouchMouseDown = sinon.spy()
      @gameControllerMock.onTouchMouseUp = sinon.spy()

    describe 'when controls are enabled', ->
  
      it 'should call onTouchMouseDown on game controller', ->
        @gameControllerMock.get = sinon.stub().withArgs('carControlsEnabled').returns true
        @controllable.onCarControlsChange()

        (jQuery @controllable.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).toHaveBeenCalled()

    describe 'when controls are disabled', ->

      it 'should not call onTouchMouseDown on game controller', ->
        @gameControllerMock.get = sinon.stub().withArgs('carControlsEnabled').returns false
        @controllable.onCarControlsChange()

        (jQuery @controllable.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).not.toHaveBeenCalled()

