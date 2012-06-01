Shared.Appendable = Ember.Mixin.create

  view: Ember.required()

  append: ->
    @view.set 'classNames', ['screen']
    @view.appendTo('#screen-container')

    Shared.FastTriggerable.apply @view

  destroy: ->
    @_super()
    @view.destroy()
