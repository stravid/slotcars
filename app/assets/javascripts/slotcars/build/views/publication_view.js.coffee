#= require slotcars/shared/views/track_view

Build.PublicationView = Shared.TrackView.extend
  
  templateName: 'slotcars_build_templates_publication_view_template'
  track: null
  stateManager: null

  onCancelButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedCancelButton'

  onPublishButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedPublishButton'

  getTrackTitleFromPublicationForm: -> @$('#track-title-input').val()