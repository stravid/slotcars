#= require slotcars/shared/views/track_view

Build.AuthorizationView = Shared.TrackView.extend Shared.Container,

  templateName: 'slotcars_build_templates_authorization_view_template'

  track: null
  stateManager: null
  delegate: null

  didInsertElement: ->
    @_super()
    @set 'view', this
    @showLoginWidget()

  onCancelButtonClicked: -> @stateManager.send 'clickedCancelButton'

  onSignUpButtonClicked: -> @showSignUpWidget()

  onSuccessfulSignIn: -> @delegate.signedIn()

  onSuccessfulSignUp: -> @delegate.signedUp()

  showLoginWidget: ->
    @_removeCurrentContentWidget()
    loginWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'LoginWidget'
    loginWidget.addToContainerAtLocation this, 'content'
    loginWidget.on 'signInSuccessful', this, 'onSuccessfulSignIn'

    @set 'showSignUpButton', false

    (@view.get 'content').set 'showCancelButton', false
    (@view.get 'content').set 'texts',
      headline: 'Save your track!'
      description: 'You need to be logged in to save your track! Please log in or sign up!'

  showSignUpWidget: ->
    @_removeCurrentContentWidget()
    signUpWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'userSignedUpSuccessfully', this, 'onSuccessfulSignUp'

    @set 'showSignUpButton', false

    (@view.get 'content').set 'showCancelButton', false
    (@view.get 'content').set 'texts',
      headline: 'Save your track!'
      description: 'You need to be logged in to save your track! Please log in or sign up!'

  _removeCurrentContentWidget: -> (@view.get 'content').destroy() if (@view.get 'content')
