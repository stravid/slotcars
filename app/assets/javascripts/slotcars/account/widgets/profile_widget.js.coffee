
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.ProfileWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.ProfileView.create delegate: this, user: Shared.User.current

Shared.WidgetFactory.getInstance().registerWidget 'ProfileWidget', Account.ProfileWidget