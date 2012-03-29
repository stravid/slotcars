
#= require slotcars/shared/lib/appendable

describe 'Appendable', ->

  Appendable = slotcars.shared.lib.Appendable

  beforeEach ->
    @viewMock =
      append: sinon.spy()
      remove: sinon.spy()

    @appendable = Ember.Object.extend(Appendable).create()
    @appendable.view = @viewMock

  it 'should require a view', ->
    (expect => Appendable.apply {}).toThrow()

  describe 'append to application', ->

    it 'should append the view to the DOM', ->
      @appendable.appendView()

      (expect @viewMock.append).toHaveBeenCalled()

  describe 'remove', ->

    beforeEach ->
      @appendable.appendView()

    it 'should remove the view from DOM', ->
      @appendable.removeView()

      (expect @viewMock.remove).toHaveBeenCalled()

  describe 'destroying', ->

    it 'should call removeView method on itself', ->
      sinon.spy @appendable, 'removeView'
      @appendable.destroy()

      (expect @appendable.removeView).toHaveBeenCalled()
