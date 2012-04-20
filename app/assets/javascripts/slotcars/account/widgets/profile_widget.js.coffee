
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.ProfileWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.ProfileView.create delegate: this, user: Shared.User.current

  signOutCurrentUser: ->
    Shared.User.signOutCurrentUser (=> @_tellAboutSuccessfulLogout()), (=> @_showErrorMessageForFailedLogout())

  _tellAboutSuccessfulLogout: -> @fire 'currentUserSignedOut'

  _showErrorMessageForFailedLogout: -> @view.set 'logoutFailed', true

Shared.WidgetFactory.getInstance().registerWidget 'ProfileWidget', Account.ProfileWidget