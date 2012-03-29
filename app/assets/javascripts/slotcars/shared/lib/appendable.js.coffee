
(namespace 'slotcars.shared.lib').Appendable = Ember.Mixin.create
  
  view: Ember.required()

  appendView: ->
    @view.append()

  removeView: ->
    @view.remove()

  destroy: ->
    @_super()
    @removeView()
