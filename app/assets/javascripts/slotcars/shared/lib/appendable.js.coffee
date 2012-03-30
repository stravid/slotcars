
(namespace 'slotcars.shared.lib').Appendable = Ember.Mixin.create
  
  view: Ember.required()

  append: ->
    @view.append()

  destroy: ->
    @_super()
    @view.remove()
    @view.destroy()
