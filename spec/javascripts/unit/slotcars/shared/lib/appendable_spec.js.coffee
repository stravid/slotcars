
#= require slotcars/shared/lib/appendable

describe 'Appendable', ->

  Appendable = Slotcars.shared.lib.Appendable

  beforeEach ->
    @viewMock =
      append: sinon.spy()
      remove: sinon.spy()

    @appendable = Ember.Object.extend(Appendable).create()

  it 'should require a view', ->
    (expect => Appendable.apply {}).toThrow()
