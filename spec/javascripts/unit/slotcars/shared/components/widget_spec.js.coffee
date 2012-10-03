describe 'Shared.Widget', ->

  it 'should always require a view', ->
    # applies the Appendable mixin on an object - assumes an error when 'view' property is not set
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Shared.Widget.apply Ember.Object.create()).toThrow()

  describe 'adding widget to container', ->

    beforeEach ->
      @containerMock = addViewAtLocation: sinon.spy()
      @viewMock = {}

      @widget = Ember.Object.extend(Shared.Widget).create view: @viewMock

    it 'should tell given container to add its view', ->
      location = 'testLocation'
      @widget.addToContainerAtLocation @containerMock, location

      (expect @containerMock.addViewAtLocation).toHaveBeenCalledWith @viewMock, location
