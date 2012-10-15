#= require slotcars/factories/screen_factory

Errors.UnsupportedScreen = Ember.Object.extend

  init: -> @view = Errors.UnsupportedScreenView.create()

Shared.ScreenFactory.getInstance().registerScreen 'UnsupportedScreen', Errors.UnsupportedScreen
