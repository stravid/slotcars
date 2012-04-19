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


  describe 'sign in user with credentials', ->

    beforeEach -> @server = sinon.fakeServer.create()

    afterEach -> @server.restore()

    describe 'successful sign in', ->

      beforeEach ->
        @serverJSONResponse = user: { id: 1, username: 'admin' }

        @server.respondWith "POST", "/users/sign_in.json", [
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
          "/users/sign_in.json",
          [401, { "Content-Type": "application/json" }, ""]
        )

      it 'should call error callback', ->
        errorCallback = sinon.spy()

        Shared.User.signIn {}, (->), errorCallback

        @server.respond()

        (expect errorCallback).toHaveBeenCalledOnce()
