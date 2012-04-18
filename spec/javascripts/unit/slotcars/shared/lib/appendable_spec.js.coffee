describe 'Appendable', ->

  Appendable = slotcars.shared.lib.Appendable

  beforeEach ->
    @viewMock =
      append: sinon.spy()
      remove: sinon.spy()
      destroy: sinon.spy()

    @appendable = Ember.Object.extend(Appendable).create
      view: @viewMock

  it 'should always require a view', ->
    # applies the Appendable mixin on an object - assumes an error when 'view' property is not set
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Appendable.apply Ember.Object.create()).toThrow()

  describe 'appending', ->

    it 'should append the view to the DOM', ->
      @appendable.append()

      (expect @viewMock.append).toHaveBeenCalled()


  describe 'destroying', ->

    it 'should remove the view from DOM', ->
      @appendable.destroy()

      (expect @viewMock.remove).toHaveBeenCalled()

    it 'should destroy the view', ->
      @appendable.destroy()

      (expect @viewMock.destroy).toHaveBeenCalled()
