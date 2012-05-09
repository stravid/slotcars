Shared.User = DS.Model.extend

  username: DS.attr 'string'
  email: DS.attr 'string'
  password: DS.attr 'string'

  highscores: null

  didLoad: -> @loadHighscores (highscores) => @set 'highscores', highscores

  loadHighscores: (callback) ->
    jQuery.ajax "/api/users/#{@get 'id'}/highscores",
      type: "GET"
      dataType: 'json'
      success: (response) -> callback response

Shared.User.reopenClass

  current: null

  signUp: (credentials) ->
    userToSignUp = Shared.User.createRecord credentials
    Shared.ModelStore.commit()

    return userToSignUp

  signIn: (credentials, successCallback, errorCallback) ->

    data =
      remote: true
      utf8: "✓"
      user: credentials

    jQuery.ajax "/api/sign_in",
      type: "POST"
      dataType: 'json'
      data: data

      success: (response) ->
        userData = response.user
        Shared.ModelStore.load Shared.User, userData

        Shared.User.current = Shared.User.find userData.id

        successCallback Shared.User.current if successCallback?

      error: (response) -> errorCallback() if errorCallback?

  signOutCurrentUser: (successCallback, errorCallback) ->

    if @current?
      jQuery.ajax "/api/sign_out",

        type: "DELETE"
        dataType: 'json'

        success: ->
          Shared.User.current = null
          successCallback() if successCallback?

        error: -> errorCallback() if errorCallback?