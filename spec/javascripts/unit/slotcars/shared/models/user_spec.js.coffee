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