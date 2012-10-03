describe 'Shared.Container', ->

  it 'should always require a view', ->
    # applies the Appendable mixin on an object - assumes an error when 'view' property is not set
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Shared.Container.apply Ember.Object.create()).toThrow()


  describe 'adding views to locations', ->

    beforeEach ->
      @containerViewMock = set: sinon.spy()
      @viewMock = {}

      @container = Ember.Object.extend(Shared.Container).create view: @containerViewMock


    it 'should tell the container view to set the view as attribute with location name', ->
      location = 'testLocation'
      @container.addViewAtLocation @viewMock, location

      (expect @containerViewMock.set).toHaveBeenCalledWith location, @viewMock
