describe 'Shared.Ghost', ->

  beforeEach -> sinon.stub Shared.ModelStore, 'commit'

  afterEach -> Shared.ModelStore.commit.restore()

  it 'should extend DS.Model', ->
    (expect Shared.Ghost).toExtend DS.Model

  describe '#save', ->

    it 'should call commit of the model store', ->
      ghost = Shared.Ghost.createRecord()
      ghost.save()

      (expect Shared.ModelStore.commit).toHaveBeenCalled()