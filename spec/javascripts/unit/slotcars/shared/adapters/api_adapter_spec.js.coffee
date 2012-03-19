
#= require slotcars/shared/adapters/api_adapter
#= require slotcars/shared/models/track

describe 'ApiAdapter', ->

  ApiAdapter = slotcars.shared.adapters.ApiAdapter
  Track = slotcars.shared.models.Track

  beforeEach ->
    @storeMock =
      loadMany: sinon.spy()
    @trackMock =
      url: 'test/url'

    @apiAdapter = ApiAdapter.create()
    @xhr = sinon.useFakeXMLHttpRequest()
    @requests = []

    @xhr.onCreate = (request) => @requests.push request

  afterEach ->
    @xhr.restore()

  describe '#findAll', ->

    it 'should make a GET request to the specified url', ->
      @apiAdapter.findAll @storeMock, @trackMock

      (expect @requests.length).toBe 1
      (expect @requests[0].url).toBe @trackMock.url
      (expect @requests[0].method).toBe 'GET'

    it 'should call the stores loadMany method with the JSON response', ->
      @apiAdapter.findAll @storeMock, @trackMock

      response = '[{ "id": 1 }, { "id": 2 }]'
      @requests[0].respond 200, { 'Content-Type': 'application/json' }, response

      (expect @storeMock.loadMany).toHaveBeenCalledWith @trackMock, (JSON.parse response)



