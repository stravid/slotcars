describe 'Shared.Appendable', ->

  beforeEach ->
    @viewMock =
      set: sinon.spy()
      appendTo: sinon.spy()
      destroy: sinon.spy()

    screen = Ember.Object.create
      view: @viewMock

    @appendable = Shared.Appendable.apply screen

  it 'should always require a view', ->
    # applies the Appendable mixin on an object - assumes an error when 'view' property is not set
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Shared.Appendable.apply Ember.Object.create()).toThrow()

  describe 'appending', ->

    it 'should add the class `screen` to the view', ->
      @appendable.append()

      (expect @viewMock.set).toHaveBeenCalledWith 'classNames'

    it 'should append the view to the DOM', ->
      @appendable.append()

      (expect @viewMock.appendTo).toHaveBeenCalled()

  describe 'destroying', ->

    it 'should destroy the view', ->
      @appendable.destroy()

      (expect @viewMock.destroy).toHaveBeenCalled()
