
#= require slotcars/shared/models/model_store

ModelStore = slotcars.shared.models.ModelStore

User = (namespace 'Slotcars.shared.models').User = DS.Model.extend

  username: DS.attr 'string'
  email: DS.attr 'string'
  password: DS.attr 'string'

User.reopenClass

  current: null

  signUp: (credentials) ->
    user = User.createRecord credentials
    ModelStore.commit()

  signIn: (credentials, successCallback, errorCallback) ->

    data =
      remote: true
      commit: "Sign in"
      utf8: "✓"
      user: credentials

    jQuery.ajax "/users/sign_in.json",
      type: "POST"
      dataType: 'json'
      data: data

      success: (response) =>
        userData = response.user
        ModelStore.load User, userData

        @current = User.find userData.id

        successCallback @current if successCallback?

      error: (response) -> errorCallback() if errorCallback?

  toString: -> 'Slotcars.shared.models.User'