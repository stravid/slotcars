Shared.Appendable = Ember.Mixin.create

  view: Ember.required()

  append: ->
    @view.set 'classNames', ['screen']
    @view.appendTo '#screen-container'

    Shared.FastTriggerable.apply @view

  destroy: ->
    @view.destroy()
    @_super()
