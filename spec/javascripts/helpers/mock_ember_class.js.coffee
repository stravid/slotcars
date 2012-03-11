@mockEmberClass = (emberClass, api) ->
  emberClassCreateStub = sinon.stub emberClass, 'create'

  api = {} if api is undefined

  api.create = emberClassCreateStub
  api.restore = -> emberClassCreateStub.restore()

  emberClassCreateStub.returns api

  return api