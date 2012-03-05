
#= require embient/ember-data
#= require slotcars/shared/models/track_model
#= require helpers/math/path

describe 'slotcars.shared.models.TrackModel', ->

  TrackModel = slotcars.shared.models.TrackModel

  it 'should be a subclass of an ember-data Model', ->
    (expect DS.Model.detect TrackModel).toBe true

  describe 'adding path points', ->

    beforeEach ->
      @PathMock = mockEmberClass helpers.math.Path,
        push: sinon.spy()

      @track = TrackModel.createRecord()

    afterEach ->
      @PathMock.restore()

    it 'should push point into its path', ->
      testPoint = x: 0, y: 0
      @track.addPathPoint testPoint

      (expect @PathMock.push).toHaveBeenCalledWith testPoint, true