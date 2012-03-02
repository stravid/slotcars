
#= require slotcars/build/build_screen

describe 'build screen', ->

  BuildScreen = slotcars.build.BuildScreen

  it 'should mark itself as buildScreen for duck typing', ->
    buildScreen = BuildScreen.create()

    (expect buildScreen.isBuildScreen).toBe true