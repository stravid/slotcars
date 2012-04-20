Shared.Run = DS.Model.extend
  time: DS.attr 'number'
  user: DS.belongsTo 'Shared.User'
  track: DS.belongsTo 'Shared.Track'