describe 'build screen view', ->

  BuildScreenView = slotcars.build.views.BuildScreenView
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager
  Button = helpers.graphic.Button

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, send: sinon.spy()
    @ButtonMock = mockEmberClass Button

    @buildScreenView = BuildScreenView.create stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()
    @ButtonMock.restore()

  it 'should extend Ember.View', ->
    (expect BuildScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    buildScreenView = BuildScreenView.create()
    container = jQuery '<div>'

    Ember.run => buildScreenView.appendTo container

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    Ember.run => buildScreenView.set 'contentView', testContentView

    (expect buildScreenView.$()).toContain '#' + testContentViewId

  it 'should create four buttons', ->
    (expect @ButtonMock.create).toHaveBeenCalledFourTimes()

  describe 'reacting to change of state manager´s current state', ->

    beforeEach ->
      @ButtonMock.reset = sinon.spy()
      @ButtonMock.set = sinon.spy()

      # just tests one case - should be enough as the buttons are all instances of one object and can´t be separated
      @currentStateMock =
        name: 'Editing'
        accessibleStates: ['Testing', 'Publishing']

    it 'should reset all buttons', ->
      @buildScreenStateManagerMock.set 'currentState', @currentStateMock # triggers observer

      (expect @ButtonMock.reset).toHaveBeenCalledFourTimes()

    it 'should enable buttons according to the accessible states', ->
      @buildScreenStateManagerMock.set 'currentState', @currentStateMock # triggers observer

      (expect @ButtonMock.set).toHaveBeenCalledWith 'disabled', false

    it 'should set button active that matches the current state', ->
      @buildScreenStateManagerMock.set 'currentState', @currentStateMock # triggers observer

      (expect @ButtonMock.set).toHaveBeenCalledWith 'active', true

  describe 'clicking on testdrive button', ->

    it 'should inform the state manager about being testdrive button clicked', ->
      @buildScreenView.testdriveButton.set 'disabled', false

      @buildScreenView.onTestdriveButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedTestdriveButton'

    it 'should not inform state manager when testdrive button is disabled', ->
      @buildScreenView.testdriveButton.set 'disabled', true

      @buildScreenView.onTestdriveButtonClicked()

      (expect @buildScreenStateManagerMock.send).not.toHaveBeenCalled()

  describe 'clicking on draw button', ->

    it 'should inform the state manager about being draw button clicked', ->
      @buildScreenView.drawButton.set 'disabled', false

      @buildScreenView.onDrawButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedDrawButton'

    it 'should not inform state manager when draw button is disabled', ->
      @buildScreenView.drawButton.set 'disabled', true

      @buildScreenView.onDrawButtonClicked()

      (expect @buildScreenStateManagerMock.send).not.toHaveBeenCalled()
