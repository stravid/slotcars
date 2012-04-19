describe 'ApiAdapter', ->

  it 'should extend RESTAdapter', ->
    (expect Shared.ApiAdapter).toExtend DS.RESTAdapter

  it 'should provide namespace property', ->
    adapterInstance = Shared.ApiAdapter.create()

    (expect adapterInstance.get 'namespace').toBe 'api'