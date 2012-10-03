describe 'Shared.BaseGameViewContainer', ->

  it 'should extend Ember.View', ->
    (expect Shared.BaseGameViewContainer).toExtend Ember.View

  describe 'setting dynamic views', ->

    beforeEach ->
      @testContentViewId = 'test-content-view'
      @testContentView = Ember.View.create elementId: @testContentViewId

      @baseGameViewContainer = Shared.BaseGameViewContainer.create()
      @baseGameViewContainer.appendTo (jQuery '<div>')

    afterEach ->
      @testContentView.destroy()
      @baseGameViewContainer.destroy()

    it 'should use a dynamic view in its template to set a track view', ->
      @baseGameViewContainer.set 'trackView', @testContentView
      Ember.run.end()

      (expect @baseGameViewContainer.$()).toContain '#' + @testContentViewId

    it 'should use a dynamic view in its template to set a car view', ->
      @baseGameViewContainer.set 'carView', @testContentView
      Ember.run.end()

      (expect @baseGameViewContainer.$()).toContain '#' + @testContentViewId

    it 'should use a dynamic view in its template to set a clock view', ->
      @baseGameViewContainer.set 'clockView', @testContentView
      Ember.run.end()

      (expect @baseGameViewContainer.$()).toContain '#' + @testContentViewId

    it 'should use a dynamic view in its template to set a game view', ->
      @baseGameViewContainer.set 'gameView', @testContentView
      Ember.run.end()

      (expect @baseGameViewContainer.$()).toContain '#' + @testContentViewId

    it 'should use a dynamic view in its template to set a ghost view', ->
      @baseGameViewContainer.set 'ghostView', @testContentView
      Ember.run.end()

      (expect @baseGameViewContainer.$()).toContain '#' + @testContentViewId

  describe 'destroying', ->

    beforeEach ->
      @viewStub =
        destroy: sinon.spy()

      @baseGameViewContainer = Shared.BaseGameViewContainer.create
        trackView: @viewStub
        carView: @viewStub
        clockView: @viewStub
        gameView: @viewStub

    it 'should call destroy on all dynamic views', ->
      @baseGameViewContainer.destroy()

      (expect @viewStub.destroy).toHaveBeenCalledFourTimes()
