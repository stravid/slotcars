describe 'Shared.User', ->

  describe 'signup user with credentials', ->

    beforeEach ->
      sinon.stub Shared.User, 'createRecord'
      sinon.stub Shared.ModelStore, 'commit'

    afterEach ->
      Shared.User.createRecord.restore()
      Shared.ModelStore.commit.restore()

    it 'should create a new user record with credentials', ->
      credentials = {}

      Shared.User.signUp credentials

      (expect Shared.User.createRecord).toHaveBeenCalledWith credentials

    it 'should tell model store to commit record', ->
      Shared.User.signUp()

      (expect Shared.ModelStore.commit).toHaveBeenCalledOnce()

    it 'should return created user model', ->
      createdUser = {}

      Shared.User.createRecord.returns createdUser

      returnedUser = Shared.User.signUp()

      (expect returnedUser).toBe createdUser


  describe 'sign in user with credentials', ->

    beforeEach -> @server = sinon.fakeServer.create()

    afterEach -> @server.restore()

    describe 'successful sign in', ->

      beforeEach ->
        @serverJSONResponse = user: { id: 1, username: 'admin' }

        @server.respondWith "POST", "/api/sign_in", [
          200, { "Content-Type": "application/json" },
          JSON.stringify @serverJSONResponse
        ]

      it 'should set current user on successful sign in', ->
        Shared.User.signIn {}

        @server.respond()

        (expect Shared.User.current).toBeInstanceOf Shared.User
        (expect Shared.User.current.get 'id').toBe @serverJSONResponse.user.id
        (expect Shared.User.current.get 'username').toBe @serverJSONResponse.user.username


      it 'should call success callback with current user on successful sign in', ->
        successCallback = sinon.spy()

        Shared.User.signIn {}, successCallback

        @server.respond()

        (expect successCallback).toHaveBeenCalledWith Shared.User.current


    describe 'failed sign in', ->

      beforeEach ->
        @server.respondWith(
          "POST",
          "/api/sign_in",
          [401, { "Content-Type": "application/json" }, ""]
        )

      it 'should call error callback', ->
        errorCallback = sinon.spy()

        Shared.User.signIn {}, (->), errorCallback

        @server.respond()

        (expect errorCallback).toHaveBeenCalledOnce()


  describe 'sign out current user', ->

    beforeEach ->
      @xhr = sinon.useFakeXMLHttpRequest()
      @requests = []

      @xhr.onCreate = (xhr) => @requests.push xhr

      Shared.User.current = Shared.User._create()

    afterEach ->
      @xhr.restore()
      Shared.User.current = null

    it 'should send sign out request if current user is set', ->
      Shared.User.signOutCurrentUser()

      (expect @requests[0].url).toBe '/api/sign_out'
      (expect @requests[0].method).toBe 'DELETE'

    it 'should not send sign out request if there is no current user', ->
      Shared.User.current = null

      Shared.User.signOutCurrentUser()

      (expect @requests.length).toBe 0

    describe 'when sign out succeeded', ->

      beforeEach ->
        @fake_authenticity_token = 'nfasdblgadsblewavdbahljv'
        @successResponseBody = JSON.stringify { new_authenticity_token: @fake_authenticity_token }

      it 'should reset current user', ->
        Shared.User.signOutCurrentUser()

        @requests[0].respond 200, { "Content-Type": "application/json" }, @successResponseBody

        (expect Shared.User.current).toBe null

      it 'should call success callback', ->
        successCallbackSpy = sinon.spy()

        Shared.User.signOutCurrentUser successCallbackSpy

        @requests[0].respond 200, { "Content-Type": "application/json" }, @successResponseBody

        (expect successCallbackSpy).toHaveBeenCalledOnce()

      it 'should update CSRF token meta-tag', ->
        Shared.User.signOutCurrentUser()

        attrSpy = sinon.spy()
        jQueryBackup = window.jQuery
        window.jQuery = sinon.stub().withArgs('meta[name="csrf-token"]').returns attr: attrSpy

        @requests[0].respond 200, { "Content-Type": "application/json" }, @successResponseBody

        (expect attrSpy).toHaveBeenCalledWith 'content', @fake_authenticity_token
        window.jQuery = jQueryBackup

    describe 'when sign out failed', ->

      it 'should not reset current user', ->
        Shared.User.signOutCurrentUser()

        @requests[0].respond 400, { "Content-Type": "application/json" }

        (expect Shared.User.current).toBeInstanceOf Shared.User

      it 'should call error callback', ->
        errorCallbackSpy = sinon.spy()

        Shared.User.signOutCurrentUser (->), errorCallbackSpy

        @requests[0].respond 400, { "Content-Type": "application/json" }

        (expect errorCallbackSpy).toHaveBeenCalledOnce()

  describe '#loadHighscore', ->

    beforeEach ->
      @xhr = sinon.useFakeXMLHttpRequest()
      @requests = []

      @xhr.onCreate = (xhr) => @requests.push xhr

      @user = Shared.User.createRecord
        id: 1

    afterEach -> @xhr.restore()

    it 'should send the correct request', ->
      @user.loadHighscores ->

      (expect @requests[0].url).toBe '/api/users/1/highscores'
      (expect @requests[0].method).toBe 'GET'

    it 'should call the callback with the response', ->
      response = '[{"id":1},{"id":2}]'
      callback = sinon.stub()

      @user.loadHighscores (highscores) => callback highscores

      @requests[0].respond 200, { "Content-Type": "application/json" }, response

      (expect callback).toHaveBeenCalledWith JSON.parse response
