#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

Errors.ErrorScreen = Ember.Object.extend Shared.Appendable,

  init: -> @view = Errors.ErrorScreenView.create()


Shared.ScreenFactory.getInstance().registerScreen 'ErrorScreen', Errors.ErrorScreen
