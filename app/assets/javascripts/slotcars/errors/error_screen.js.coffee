#= require slotcars/shared/mixins/appendable
#= require slotcars/factories/screen_factory

Errors.ErrorScreen = Ember.Object.extend Shared.Appendable,

  init: -> @view = Errors.ErrorScreenView.create()


Shared.ScreenFactory.getInstance().registerScreen 'ErrorScreen', Errors.ErrorScreen
