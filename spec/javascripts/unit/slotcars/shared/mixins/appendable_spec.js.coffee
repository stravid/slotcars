describe 'Shared.Appendable', ->

  beforeEach ->
    @viewMock =
      append: sinon.spy()
      destroy: sinon.spy()

    @appendable = Ember.Object.extend(Shared.Appendable).create
      view: @viewMock

  it 'should always require a view', ->
    # applies the Appendable mixin on an object - assumes an error when 'view' property is not set
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Shared.Appendable.apply Ember.Object.create()).toThrow()

  describe 'appending', ->

    it 'should append the view to the DOM', ->
      @appendable.append()

      (expect @viewMock.append).toHaveBeenCalled()


  describe 'destroying', ->

    it 'should destroy the view', ->
      @appendable.destroy()

      (expect @viewMock.destroy).toHaveBeenCalled()
