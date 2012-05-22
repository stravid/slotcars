describe 'Shared.Track', ->

  it 'should be a subclass of an ember-data Model', ->
    (expect Shared.Track).toExtend DS.Model

  beforeEach ->
    @raphaelPathMock = mockEmberClass Shared.RaphaelPath, setRaphaelPath: sinon.spy(), setRasterizedPath: sinon.spy()
    @track = Shared.Track.createRecord()

  afterEach ->
    @raphaelPathMock.restore()


  describe 'binding raphael path', ->

    it 'should bind raphaelPath property to path of RaphaelPath instance', ->
      expectedPathValue = 'test'

      @raphaelPathMock.set 'path', expectedPathValue

      Ember.run.end()

      (expect @track.get 'raphaelPath').toEqual expectedPathValue


  describe 'adding path points', ->

    it 'should tell its raphael path to add points', ->
      point = { x: 1, y: 0 }
      @raphaelPathMock.addPoint = sinon.spy()

      @track.addPathPoint point

      (expect @raphaelPathMock.addPoint).toHaveBeenCalledWith point


  describe 'getting all path points', ->

    it 'should ask its raphael path for path points as an array', ->
      @raphaelPathMock.getPathPointArray = sinon.spy()

      @track.getPathPoints()

      (expect @raphaelPathMock.getPathPointArray).toHaveBeenCalled()


  describe 'getting total length of path', ->

    it 'should ask its raphael path for total length', ->
      expectedLength = Math.random() * 10
      @raphaelPathMock.get = sinon.stub().withArgs('totalLength').returns expectedLength

      totalLength = @track.getTotalLength()

      (expect totalLength).toBe expectedLength

  describe 'determine if track is long enough', ->

    it 'should return true if the track´s total length is high enough', ->
      @raphaelPathMock.get = sinon.stub().withArgs('totalLength').returns 400.1

      isLengthValid = @track.hasValidTotalLength()

      (expect isLengthValid).toBe true

    it 'should return false if the track´s total length too low', ->
      @raphaelPathMock.get = sinon.stub().withArgs('totalLength').returns 399.9

      isLengthValid = @track.hasValidTotalLength()

      (expect isLengthValid).toBe false

  describe 'getting point on length of track', ->

    it 'should return the point at specific length on path', ->
      length = 1
      fakePointAtLength = {}
      @raphaelPathMock.getPointAtLength = sinon.stub().withArgs(length).returns fakePointAtLength

      resultPoint = @track.getPointAtLength length

      (expect resultPoint).toBe fakePointAtLength


  describe 'clearing the path', ->

    beforeEach -> @raphaelPathMock.clear = sinon.spy()

    it 'should tell the path to clear', ->
      @track.clearPath()

      (expect @raphaelPathMock.clear).toHaveBeenCalled()


  describe 'cleaning the path', ->

    beforeEach ->
      @raphaelPathMock.clean = sinon.spy()
      @raphaelPathMock.rasterize = sinon.spy()

    it 'should tell the path to clean itself', ->
      @track.cleanPath()

      (expect @raphaelPathMock.clean).toHaveBeenCalled()

    it 'should not tell the raphael path to rasterize immediately', ->
      @track.cleanPath()

      (expect @raphaelPathMock.rasterize).not.toHaveBeenCalled()


  describe 'lap count for tracks', ->

    it 'should return the same static number of laps for all tracks', ->
      (expect @track.get 'numberOfLaps').toBe 3


  describe 'asking if specific length on track is after finish line', ->

    beforeEach ->
      @fakePathLength = 1
      @raphaelPathMock.totalLength = @fakePathLength

    it 'should return true when asked for length after finish line', ->
      lengthThatShouldBeAfter = (@track.get 'numberOfLaps') * @fakePathLength + 0.00001
      (expect @track.isLengthAfterFinishLine lengthThatShouldBeAfter).toBe true

    it 'should return false when asked length is before finish line', ->
      lengthThatShouldNotBeAfter = (@track.get 'numberOfLaps') * @fakePathLength - 0.00001
      (expect @track.isLengthAfterFinishLine lengthThatShouldNotBeAfter).toBe false


  describe 'asking for lap at length', ->

    beforeEach ->
      @fakePathLength = 1
      @raphaelPathMock.totalLength = @fakePathLength

    it 'should return first lap for lengths smaller than the path length', ->
      lengthLessThanFirstLap = @fakePathLength - 0.0001

      (expect @track.lapForLength lengthLessThanFirstLap).toBe 1

    it 'should return second lap for length between first and second lap', ->
      lengthBetweenFirstAndSecondLap = @fakePathLength + 0.0001

      (expect @track.lapForLength lengthBetweenFirstAndSecondLap).toBe 2

    it 'should clamp the return value to maximum number of laps', ->
      lengthBiggerThanTotalLaps = @fakePathLength * (@track.get 'numberOfLaps') + 1

      (expect @track.lapForLength lengthBiggerThanTotalLaps).toBe @track.get 'numberOfLaps'


  describe 'updating raphael path', ->

    beforeEach -> @raphaelPathMock.setLinkedPath = sinon.spy()

    it 'should pass the passed points to the linked path', ->
      points = [ { x: 1, y: 0 }, { x: 0, y: 1 } ]

      @track.updateRaphaelPath points

      (expect @raphaelPathMock.setLinkedPath).toHaveBeenCalledWith points


    describe '#didLoad', ->

      it 'should setup the raphael path', ->
        raphael = 'M0,0L1,0z'
        rasterized = '[{"x":"1.00","y":"1.00","angle":"1.00"}]'
        points = JSON.parse rasterized

        @track.set 'raphael', raphael
        @track.set 'rasterized', rasterized

        @track.didLoad()

        (expect @raphaelPathMock.setRaphaelPath).toHaveBeenCalledWith raphael
        (expect @raphaelPathMock.setRasterizedPath).toHaveBeenCalledWith points

    describe '#save', ->

      beforeEach ->
        @raphaelPathMock.get = sinon.stub()
        @raphaelPathMock.get.withArgs('_rasterizedPath').returns { asFixedLengthPointArray: -> }
        @raphaelPathMock.get.withArgs('path').returns ''

        sinon.stub Shared.ModelStore, 'commit'

      afterEach ->
        Shared.ModelStore.commit.restore()

      it 'should call commit on the model store', ->
        @track.save()

        (expect Shared.ModelStore.commit).toHaveBeenCalledOnce()

      it 'should set the raphael property', ->
        path = 'M0,0L1,1z'
        @raphaelPathMock.get.withArgs('path').returns path

        @track.save()

        (expect @track.get 'raphael').toBe path

      it 'should set the rasterized property', ->
        fixedLengthPointArray = [
          { x: '1.00', y: '1.00', angle: '1.00' }
        ]
        @raphaelPathMock.get.withArgs('_rasterizedPath').returns { asFixedLengthPointArray: -> fixedLengthPointArray }

        @track.save()

        (expect @track.get 'rasterized').toBe JSON.stringify fixedLengthPointArray

  describe '#loadHighscores', ->

    beforeEach ->
      @xhr = sinon.useFakeXMLHttpRequest()
      @requests = []

      @xhr.onCreate = (xhr) => @requests.push xhr

      @track = Shared.Track.createRecord
        id: 1

    afterEach -> @xhr.restore()

    it 'should send the correct request', ->
      @track.loadHighscores ->

      (expect @requests[0].url).toBe '/api/tracks/1/highscores'
      (expect @requests[0].method).toBe 'GET'

    it 'should call the callback with the response', ->
      response = '[{"id":1},{"id":2}]'
      callback = sinon.stub()

      @track.loadHighscores (highscores) => callback highscores

      @requests[0].respond 200, { "Content-Type": "application/json" }, response

      (expect callback).toHaveBeenCalledWith JSON.parse response

  describe 'finding random track', ->

    beforeEach ->
      @xhr = sinon.useFakeXMLHttpRequest()
      @requests = []

      @xhr.onCreate = (xhr) => @requests.push xhr

    afterEach ->
      @xhr.restore()

    it 'should request a random track from the server', ->
      Shared.Track.findRandom()

      (expect @requests[0].url).toBe '/api/tracks/random'
      (expect @requests[0].method).toBe 'GET'

    it 'should return a track record in loading state', ->
      record = Shared.Track.findRandom()

      (expect record).toBeInstanceOf Shared.Track
      (expect record.get 'isLoaded').toBe false

    describe 'when request succeeds', ->

      beforeEach ->
        @responseJSON = track: { id: 42, raphael: 'M0,0R1,1,0,1z', rasterized: '[{"x":"1.00","y":"1.00","angle":"1.00"}]' }

      it 'should load the response into the model store', ->
        sinon.spy Shared.ModelStore, 'load'

        Shared.Track.findRandom()
        @requests[0].respond 200, { "Content-Type": "application/json" }, JSON.stringify @responseJSON

        (expect Shared.ModelStore.load).toHaveBeenCalledWith Shared.Track, @responseJSON.track

      it 'should update the returned track record', ->
        record = Shared.Track.findRandom()
        @requests[0].respond 200, { "Content-Type": "application/json" }, JSON.stringify @responseJSON

        (expect record.get 'id').toEqual 42


  describe 'setting title of track', ->

    describe 'valid title provided', ->

      it 'should set the title attribute on the track', ->
        testTitle = "muh"

        @track.setTitle testTitle

        (expect @track.get 'title').toBe testTitle


    describe 'invalid title provided', ->

      beforeEach -> sinon.stub @track, 'setRandomTitle'

      it 'should set random title when title is empty', ->
        @track.setTitle ''

        (expect @track.setRandomTitle).toHaveBeenCalled()


  describe 'setting random title', ->

    it 'should set a random track title from the random track titles array', ->
      @track.setRandomTitle()

      (expect Shared.Track.RANDOM_TRACK_TITLES).toContain @track.get 'title'