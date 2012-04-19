
(namespace 'Slotcars.shared.lib').IdObservable = Ember.Mixin.create

  init: ->
    @_super()
    @addObserver 'id', this, '_onIdChanged'

  _onIdChanged: ->
    if (@get 'id')?
      @didDefineId() if @didDefineId?
      @removeObserver 'id', this, '_onIdChanged'
