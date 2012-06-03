Shared.User = DS.Model.extend

  username: DS.attr 'string'
  email: DS.attr 'string'
  password: DS.attr 'string'

  highscores: null

  didLoad: -> @updateHighscores()

  updateHighscores: -> @loadHighscores (highscores) => @set 'highscores', highscores

  loadHighscores: (callback) ->
    jQuery.ajax "/api/users/#{@get 'id'}/highscores",
      type: "GET"
      dataType: 'json'
      success: (response) -> callback response

  getTimeForTrackId: (trackId) ->
    return null unless @highscores?

    for highscore in @highscores
      return highscore.time if highscore.track_id is trackId

Shared.User.reopenClass

  current: null

  signUp: (credentials) ->
    transaction = Shared.ModelStore.transaction()
    userToSignUp = transaction.createRecord Shared.User, credentials
    transaction.commit()

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

        success: (data) ->
          Shared.User.current = null
          successCallback() if successCallback?
          (jQuery 'meta[name="csrf-token"]').attr 'content', data.new_authenticity_token

        error: -> errorCallback() if errorCallback?
