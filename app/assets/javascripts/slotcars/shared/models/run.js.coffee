Shared.Run = DS.Model.extend Shared.IdObservable,
  time: DS.attr 'number'
  user: DS.belongsTo 'Shared.User'
  track: DS.belongsTo 'Shared.Track'

  save: (@_creationCallback) ->
    Shared.ModelStore.commit()

  # Use the IdObservable mixin to ensure to get notified as soon as
  # the 'id' property is available - ember-data´s 'didCreate' callback is called too early.
  # This is a temporary fix - if ember-data worked as expected, the IdObservable would no longer be needed!
  didCreatePersistently: ->
    if @_creationCallback?
      Ember.run.next =>
        @_creationCallback()
        @_creationCallback = null