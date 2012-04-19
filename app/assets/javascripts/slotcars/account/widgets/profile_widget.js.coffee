
#= require slotcars/shared/components/widget
#= require slotcars/account/views/profile_view
#= require slotcars/factories/widget_factory
#= require slotcars/shared/models/user

Widget = Slotcars.shared.components.Widget
ProfileView = Slotcars.account.views.ProfileView
WidgetFactory = Slotcars.factories.WidgetFactory
User = Slotcars.shared.models.User

ProfileWidget = (namespace 'Slotcars.account.widgets').ProfileWidget = Ember.Object.extend Widget, Ember.Evented,

  init: -> @set 'view', ProfileView.create delegate: this, user: User.current

WidgetFactory.getInstance().registerWidget 'ProfileWidget', ProfileWidget