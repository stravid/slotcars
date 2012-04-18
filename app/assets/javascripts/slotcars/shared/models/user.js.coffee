
#= require slotcars/shared/models/model_store

ModelStore = slotcars.shared.models.ModelStore

User = (namespace 'Slotcars.shared.models').User = DS.Model.extend

  username: DS.attr 'string'
  email: DS.attr 'string'
  password: DS.attr 'string'

User.reopenClass

  signUp: (credentials) ->
    user = User.createRecord credentials
    ModelStore.commit()

  toString: -> 'Slotcars.shared.models.User'