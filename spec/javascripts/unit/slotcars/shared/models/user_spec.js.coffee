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