Shared.Ghost = DS.Model.extend

  positions: DS.attr 'json'
  time: DS.attr 'number'
  user: DS.belongsTo 'Shared.User'
  track: DS.belongsTo 'Shared.Track'

  save: ->
    Shared.ModelStore.commit()
