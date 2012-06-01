#= require slotcars/factories/screen_factory

Errors.ErrorScreen = Ember.Object.extend

  init: -> @view = Errors.ErrorScreenView.create()


Shared.ScreenFactory.getInstance().registerScreen 'ErrorScreen', Errors.ErrorScreen
