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


  describe 'signin current user out', ->

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

    it 'should reset current user if request was successful', ->
      Shared.User.signOutCurrentUser()

      @requests[0].respond 200, { "Content-Type": "application/json" }

      (expect Shared.User.current).toBe null

    it 'should not reset current user if request had errors', ->
      Shared.User.signOutCurrentUser()

      @requests[0].respond 400, { "Content-Type": "application/json" }

      (expect Shared.User.current).toBeInstanceOf Shared.User

    it 'should call success callback when user was signed out successfully', ->
      successCallbackSpy = sinon.spy()

      Shared.User.signOutCurrentUser successCallbackSpy

      @requests[0].respond 200, { "Content-Type": "application/json" }

      (expect successCallbackSpy).toHaveBeenCalledOnce()

    it 'should call error callback when sign out failed', ->
      errorCallbackSpy = sinon.spy()

      Shared.User.signOutCurrentUser (->), errorCallbackSpy

      @requests[0].respond 400, { "Content-Type": "application/json" }

      (expect errorCallbackSpy).toHaveBeenCalledOnce()