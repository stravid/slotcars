Ember.View.reopen
  didInsertElement: ->
    @set('elementInDOM', true)
    @_super()

  willDestroyElement: ->
    @set('elementInDOM', false)
    @_super()
