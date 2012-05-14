Build.AuthorizationView = Ember.View.extend Shared.Container,

  templateName: 'slotcars_build_templates_authorization_view_template'

  stateManager: null
  delegate: null

  didInsertElement: ->
    @set 'view', this

    @showLoginWidget()

  onCancelButtonClicked: ->
    @stateManager.send 'clickedCancelButton'

  onSuccessfulSignIn: ->
    @delegate.signedIn()

  onSuccessfulSignUp: ->
    @delegate.signedUp()

  showLoginWidget: ->
    @_removeCurrentContentWidget()
    loginWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'LoginWidget'
    loginWidget.addToContainerAtLocation this, 'content'
    loginWidget.on 'signUpClicked', this, 'showSignUpWidget'
    loginWidget.on 'signInSuccessful', this, 'onSuccessfulSignIn'

  showSignUpWidget: ->
    @_removeCurrentContentWidget()
    signUpWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'userSignedUpSuccessfully', this, 'onSuccessfulSignUp'
    signUpWidget.on 'signUpCancelled', this, 'showLoginWidget'

  _removeCurrentContentWidget: -> (@view.get 'content').destroy() if (@view.get 'content')