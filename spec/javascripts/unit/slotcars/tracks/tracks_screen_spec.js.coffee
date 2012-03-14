
#= require slotcars/tracks/tracks_screen

describe 'tracks screen', ->

  TracksScreen = slotcars.tracks.TracksScreen
  TracksController = slotcars.tracks.controllers.TracksController

  it 'should extend Ember.Object', ->
    (expect TracksScreen).toExtend Ember.Object


  describe 'appending tracks screen to application', ->

    it 'should create the tracks controller', ->
      @TracksControllerMock = mockEmberClass TracksController

      tracksScreen = TracksScreen.create()
      tracksScreen.appendToApplication()

      (expect @TracksControllerMock.create).toHaveBeenCalled()