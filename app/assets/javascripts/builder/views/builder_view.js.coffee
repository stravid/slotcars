#= require helpers/namespace
#= require helpers/event_normalize

#= require builder/templates/builder_template

#= require shared/mediators/current_track_mediator
#= require builder/mediators/builder_mediator

namespace 'builder.views'

builder.views.BuilderView = Ember.View.extend

  elementId: 'builder-view'
  templateName: 'builder_templates_builder_template'

  currentTrackMediator: shared.mediators.currentTrackMediator
  builderMediator: builder.mediators.builderMediator
  builderController: null
  paper: null

  currentTrackBinding: 'currentTrackMediator.currentTrack'
  linkToBuiltTrackBinding: 'currentTrackMediator.showRoute'

  didInsertElement: ->
    @_setupDrawEventListeners()

  _onTouchMouseMove: (event) ->
    event.originalEvent.preventDefault()

    point = @_removeOffsetFromPoint { x: event.pageX, y: event.pageY }

    @builderController.onTouchMouseMove point
    @_drawPoint point

  _onTouchMouseUp: (event) ->
    @_removeDrawEventListeners()

    (jQuery '#builder-delete-button').on 'touchMouseUp', (event) => @_onBuilderDeleteButtonTouchMouseUp(event)

    @builderController.onTouchMouseUp event

    @_drawPath()

  _onBuilderDeleteButtonTouchMouseUp: (event) ->
    event.stopPropagation()

    (jQuery '#builder-delete-button').off 'touchMouseUp'

    @builderController.resetPath()
    @_clear()
    @_setupDrawEventListeners()

  _clear: ->
    @paper.clear()

  _drawPoint: (point)->
    @paper.circle point.x, point.y, 0.5

  _drawPath: ->
    @_clear()

    pathString = "M"

    for point in @builderMediator.points
      pathString += "#{point.x},#{point.y}L"

    pathString = pathString.substr 0, pathString.length - 1
    pathString += "Z"

    @paper.path pathString

  _removeOffsetFromPoint: (point) ->
    offset = (jQuery '#builder-application').offset()

    if offset?
      point.x -= offset.left
      point.y -= offset.top

    point

  _setupDrawEventListeners: ->
    (jQuery '#builder-application').on 'touchMouseMove', (event) => @_onTouchMouseMove(event)
    (jQuery '#builder-application').on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  _removeDrawEventListeners: ->
    (jQuery '#builder-application').off 'touchMouseMove'
    (jQuery '#builder-application').off 'touchMouseUp'
