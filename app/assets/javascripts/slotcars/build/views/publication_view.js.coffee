
#= require slotcars/shared/views/track_view
#= require slotcars/build/templates/publication_view_template

TrackView = slotcars.shared.views.TrackView

(namespace 'Slotcars.build.views').PublicationView = TrackView.extend
  
  templateName: 'slotcars_build_templates_publication_view_template'
  track: null
  stateManager: null

  onCancelButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedCancelButton'

  onPublishButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedPublishButton'
