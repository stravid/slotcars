describe 'slotcars application screen management', ->

  beforeEach -> @RouteManagerMock = mockEmberClass Shared.RouteManager, start: sinon.stub()

  afterEach -> @RouteManagerMock.restore()

  describe '#ready', ->

    beforeEach ->
      Ember.run => @slotcarsApplication = SlotcarsApplication.create()

    afterEach -> @slotcarsApplication.destroy()

    it 'should create route manager and register itself as delegate', ->
      (expect @RouteManagerMock.create).toHaveBeenCalledWithAnObjectLike
        delegate: @slotcarsApplication

    it 'should make the route manager a singleton that can be directly accessed', ->
      (expect Shared.routeManager).toBe @RouteManagerMock

    it 'should start the route manager', ->
      (expect Shared.routeManager.start).toHaveBeenCalled()


  describe '#showScreen', ->

    beforeEach ->
      @screenMock = append: sinon.spy()
      @screenFactoryMock = getInstanceOf: sinon.stub().returns @screenMock

      (sinon.stub Shared.ScreenFactory, 'getInstance').returns @screenFactoryMock

      Ember.run => @slotcarsApplication = SlotcarsApplication.create()

    afterEach ->
      @slotcarsApplication.destroy()
      Shared.ScreenFactory.getInstance.restore()

    it 'should get the correct screen from factory and tell it to append', ->
      createParameters = {}
      @slotcarsApplication.showScreen 'ExampleScreen', createParameters

      (expect @screenFactoryMock.getInstanceOf).toHaveBeenCalledWith 'ExampleScreen', createParameters
      (expect @screenMock.append).toHaveBeenCalled()


  describe '#isBrowserSupported', ->

    beforeEach ->
      @browserBackup = jQuery.browser
      Ember.run => @slotcarsApplication = SlotcarsApplication.create()

      sinon.spy @slotcarsApplication, 'isBrowserSupported'

    afterEach ->
      jQuery.browser = @browserBackup
      @slotcarsApplication.destroy()

    it 'should return true if browser is chrome or safari and engine is webkit', ->
      @slotcarsApplication.isBrowserSupported()

      (expect @slotcarsApplication.isBrowserSupported).toHaveReturned true

    it 'should return false if browser engine is not webkit', ->
      jQuery.browser.webkit = false

      @slotcarsApplication.isBrowserSupported()

      (expect @slotcarsApplication.isBrowserSupported).toHaveReturned false
