Shared.Run = DS.Model.extend
  time: DS.attr 'number'
  user: DS.belongsTo 'Shared.User'
  track: DS.belongsTo 'Shared.Track'

  save: (@_creationCallback) ->
    Shared.ModelStore.commit()

  didCreate: ->
    if @_creationCallback?
      Ember.run.next =>
        @_creationCallback()
        @_creationCallback = null
