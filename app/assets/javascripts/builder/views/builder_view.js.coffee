#= require helpers/namespace
#= require helpers/event_normalize

#= require builder/templates/builder_template

namespace 'builder.views'

builder.views.BuilderView = Ember.View.extend

  elementId: 'builder-view'
  templateName: 'builder_templates_builder_template'

  builderController: null
  paper: null
  trackMediator: null

  builtTrackBinding: 'trackMediator.builtTrack'
  linkToBuiltTrack: (Ember.computed ->
    builtTrack = (@get 'builtTrack')
    if builtTrack then "tracks/#{(builtTrack.get 'clientId')}"
  ).property 'builtTrack'

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

    for point in @trackMediator.points
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
