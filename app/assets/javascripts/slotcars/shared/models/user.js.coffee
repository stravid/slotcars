Shared.User = DS.Model.extend

  username: DS.attr 'string'
  email: DS.attr 'string'
  password: DS.attr 'string'

Shared.User.reopenClass

  signUp: (credentials) ->
    user = Shared.User.createRecord credentials
    Shared.ModelStore.commit()

  toString: -> 'Shared.User'