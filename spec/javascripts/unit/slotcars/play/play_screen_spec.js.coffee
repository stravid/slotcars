
#= require slotcars/play/play_screen

describe 'play screen', ->

  PlayScreen = slotcars.play.PlayScreen

  it 'should mark itself as playScreen for duck typing', ->
    playScreen = PlayScreen.create()

    (expect playScreen.isPlayScreen).toBe true