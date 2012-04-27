describe 'Shared.Run', ->

  beforeEach ->
    sinon.stub Shared.ModelStore, 'commit'

  afterEach ->
    Shared.ModelStore.commit.restore()

  it 'should extend DS.Model', ->
    (expect Shared.Run).toExtend DS.Model

  describe '#save', ->

    it 'should call commit of the model store', ->
      run = Shared.Run.createRecord()
      run.save()

      (expect Shared.ModelStore.commit).toHaveBeenCalled()