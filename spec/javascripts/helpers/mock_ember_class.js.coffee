@mockEmberClass = (emberClass, api) ->
  emberClassCreateStub = sinon.stub emberClass, 'create'

  api = {} if api is undefined

  api.create = emberClassCreateStub
  api.restore = -> emberClassCreateStub.restore()

  apiObject = Ember.Object.create api
  apiObject.set = api.set if api.set?
  apiObject.get = api.get if api.get?

  emberClassCreateStub.returns apiObject

  return apiObject