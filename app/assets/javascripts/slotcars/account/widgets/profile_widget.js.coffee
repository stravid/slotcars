
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.ProfileWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: ->
    @loadNewestUserHighscores()
    @set 'view', Account.ProfileView.create delegate: this, user: Shared.User.current

  signOutCurrentUser: ->
    Shared.User.signOutCurrentUser (=> @_tellAboutSuccessfulLogout()), (=> @_showErrorMessageForFailedLogout())

  _tellAboutSuccessfulLogout: -> @fire 'currentUserSignedOut'

  _showErrorMessageForFailedLogout: -> @view.set 'logoutFailed', true

  loadNewestUserHighscores: -> Shared.User.current.updateHighscores()

Shared.WidgetFactory.getInstance().registerWidget 'ProfileWidget', Account.ProfileWidget