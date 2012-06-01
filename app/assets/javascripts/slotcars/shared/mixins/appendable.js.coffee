Shared.Appendable = Ember.Mixin.create

  view: Ember.required()

  append: ->
    Shared.FastTriggerable.apply @view
    @view.append()

  destroy: ->
    @_super()
    @view.remove()
    @view.destroy()
