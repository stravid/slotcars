describe 'ApiAdapter', ->

  beforeEach -> @adapterInstance = Shared.ApiAdapter.create()

  it 'should extend RESTAdapter', ->
    (expect Shared.ApiAdapter).toExtend DS.RESTAdapter

  it 'should provide namespace property', ->
    (expect @adapterInstance.get 'namespace').toBe 'api'


  describe 'handling of validation errors on create', ->

    beforeEach -> @server = sinon.fakeServer.create()

    afterEach -> @server.restore()

    it 'should set the validation errors on the record', ->
      validationErrors = errors: { first: ["false"], second: ["false", "too"] }
      @server.respondWith "POST", "/api/users", [
        422, { "Content-Type": "application/json" },
        JSON.stringify validationErrors
      ]

      testUser = Shared.User._create()

      @adapterInstance.createRecord {}, Shared.User, testUser

      @server.respond()

      (expect testUser.get 'hasValidationErrors').toBe true
      (expect testUser.get 'validationErrors').toEqual validationErrors.errors