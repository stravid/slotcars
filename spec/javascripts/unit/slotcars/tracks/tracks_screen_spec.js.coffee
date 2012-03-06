
describe 'tracks screen', ->

  TracksScreen = slotcars.tracks.TracksScreen

  it 'should mark itself as tracksScreen for duck typing', ->
    tracksScreen = TracksScreen.create()

    (expect tracksScreen.isTracksScreen).toBe true