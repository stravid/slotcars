Shared.Appendable = Ember.Mixin.create

  view: Ember.required()

  append: ->
    @view.set 'classNames', ['screen']
    @view.appendTo('#gras')

  destroy: ->
    @_super()
    @view.destroy()
