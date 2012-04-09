
#= require slotcars/shared/adapters/api_adapter
#= require slotcars/shared/models/track

describe 'ApiAdapter', ->

  ApiAdapter = slotcars.shared.adapters.ApiAdapter

  it 'should extend RESTAdapter', ->
    (expect ApiAdapter).toExtend DS.RESTAdapter

  it 'should provide namespace property', ->
    adapterInstance = ApiAdapter.create()

    (expect adapterInstance.get 'namespace').toBe 'api'