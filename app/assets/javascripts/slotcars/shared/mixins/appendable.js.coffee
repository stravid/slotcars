Shared.Appendable = Ember.Mixin.create

  view: Ember.required()

  append: ->
    @view.set 'classNames', ['screen']
    @view.appendTo('#screen-container')

  destroy: ->
    @_super()
    @view.destroy()
