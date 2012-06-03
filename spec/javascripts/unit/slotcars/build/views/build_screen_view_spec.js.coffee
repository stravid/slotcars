describe 'build screen view', ->

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager, send: sinon.spy()
    @ButtonMock = mockEmberClass Shared.Button

    @buildScreenView = Build.BuildScreenView.create stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()
    @ButtonMock.restore()

  it 'should extend Ember.View', ->
    (expect Build.BuildScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    buildScreenView = Build.BuildScreenView.create()

    Ember.run => buildScreenView.appendTo jQuery '<div>'

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
        reachableStates: ['Testing', 'Publishing']

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

    it 'should inform the state manager about testdrive button being clicked', ->
      @buildScreenView.testdriveButton.set 'disabled', false

      @buildScreenView.onTestdriveButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedTestdriveButton'

  describe 'clicking on draw button', ->

    it 'should inform the state manager about draw button being clicked', ->
      @buildScreenView.drawButton.set 'disabled', false

      @buildScreenView.onDrawButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedDrawButton'

  describe 'clicking on edit button', ->

    it 'should inform the state manager about edit button being clicked', ->
      @buildScreenView.editButton.set 'disabled', false

      @buildScreenView.onEditButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedEditButton'

  describe 'clicking on publish button', ->

    it 'should inform the state manager about publish button being clicked', ->
      @buildScreenView.drawButton.set 'disabled', false

      @buildScreenView.onPublishButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedPublishButton'
