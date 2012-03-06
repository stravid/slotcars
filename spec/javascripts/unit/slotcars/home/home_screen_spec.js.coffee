
#= require slotcars/home/home_screen

describe 'home screen', ->

  HomeScreen = slotcars.home.HomeScreen

  it 'should mark itself as home screen for duck typing', ->
    homeScreen = HomeScreen.create()

    (expect homeScreen.isHomeScreen).toBe true