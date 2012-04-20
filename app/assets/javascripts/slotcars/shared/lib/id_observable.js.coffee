Shared.IdObservable = Ember.Mixin.create

  init: ->
    @_super()
    @addObserver 'id', this, '_onIdChanged'

  _onIdChanged: ->
    if (@get 'id')?
      @didCreatePersistently()
      @removeObserver 'id', this, '_onIdChanged'
