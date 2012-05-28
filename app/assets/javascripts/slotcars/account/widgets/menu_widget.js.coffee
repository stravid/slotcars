
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.MenuWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.MenuView.create delegate: this
  
  switchToSignUp: -> @fire 'signUpClicked'
  
  switchToLogin: -> @fire 'loginClicked'

Shared.WidgetFactory.getInstance().registerWidget 'MenuWidget', Account.MenuWidget