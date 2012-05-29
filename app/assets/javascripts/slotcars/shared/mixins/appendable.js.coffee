Shared.Appendable = Ember.Mixin.create

  view: Ember.required()

  append: ->
    @view.append()

  destroy: ->
    @_super()
    @view.destroy()
