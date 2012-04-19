describe 'Slotcars.shared.models.User', ->

  User = Slotcars.shared.models.User
  ModelStore = slotcars.shared.models.ModelStore

  describe 'signup user with credentials', ->

    beforeEach ->
      sinon.stub User, 'createRecord'
      sinon.stub ModelStore, 'commit'

    afterEach ->
      User.createRecord.restore()
      ModelStore.commit.restore()

    it 'should create a new user record with credentials', ->
      credentials = {}

      User.signUp credentials

      (expect User.createRecord).toHaveBeenCalledWith credentials

    it 'should tell model store to commit record', ->
      User.signUp()

      (expect ModelStore.commit).toHaveBeenCalledOnce()


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
        User.signIn {}

        @server.respond()

        (expect User.current).toBeInstanceOf User
        (expect User.current.get 'id').toBe @serverJSONResponse.user.id
        (expect User.current.get 'username').toBe @serverJSONResponse.user.username


      it 'should call success callback with current user on successful sign in', ->
        successCallback = sinon.spy()

        User.signIn {}, successCallback

        @server.respond()

        (expect successCallback).toHaveBeenCalledWith User.current


    describe 'failed sign in', ->

      beforeEach ->
        @server.respondWith(
          "POST",
          "/users/sign_in.json",
          [401, { "Content-Type": "application/json" }, ""]
        )

      it 'should call error callback', ->
        errorCallback = sinon.spy()

        User.signIn {}, (->), errorCallback

        @server.respond()

        (expect errorCallback).toHaveBeenCalledOnce()