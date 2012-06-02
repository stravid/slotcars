#= require slotcars/shared/views/track_view

Build.PublicationView = Shared.TrackView.extend

  templateName: 'slotcars_build_templates_publication_view_template'
  track: null
  stateManager: null

  texts: {}

  # form field property
  trackTitle: ''

  didInsertElement: ->
    @_setHeadline()
    @_super()

  onCancelButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedCancelButton'

  submit: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedPublishButton'

  _setHeadline: ->
    username = (Shared.User.current.get 'username')
    username = ', ' + username unless username.length > 10

    @set 'texts', headline: 'Nice track' + username + ' !'
