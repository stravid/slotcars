#= require helpers/namespace
#= require helpers/event_normalize

#= require builder/templates/builder_template

namespace 'builder.views'

builder.views.BuilderView = Ember.View.extend

  elementId: 'builder-view'
  templateName: 'builder_templates_builder_template'

  builderController: null
  paper: null

  didInsertElement: ->
    (jQuery '#builder-application').on 'touchMouseMove', (event) => @_onTouchMouseMove(event)
    (jQuery '#builder-application').on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  _onTouchMouseMove: (event) ->
    event.originalEvent.preventDefault()

    point = @_removeOffsetFromPoint { x: event.pageX, y: event.pageY }

    @builderController.onTouchMouseMove point
    @_drawPoint point

  _onTouchMouseUp: (event) ->
    (jQuery '#builder-application').off 'touchMouseMove'
    (jQuery '#builder-application').off 'touchMouseUp'

    (jQuery '#builder-delete-button').on 'touchMouseUp', (event) => @_onBuilderDeleteButtonTouchMouseUp(event)

    @builderController.onTouchMouseUp event

    @_redraw()
    @_drawPath()

  _onBuilderDeleteButtonTouchMouseUp: (event) ->
    event.stopPropagation()

    (jQuery '#builder-delete-button').off 'touchMouseUp'

    @_clear()

    (jQuery '#builder-application').on 'touchMouseMove', (event) => @_onTouchMouseMove(event)
    (jQuery '#builder-application').on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  _clear: ->
    @paper.clear()
    @mediator.points = []

  _redraw: ->
    @paper.clear()

    length = @mediator.points.length
    points = @mediator.points

    for point in points
      @_drawPoint point.x, point.y

  _drawPoint: (point)->
    @paper.circle point.x, point.y, 0.5

  _drawPath: ->
    pathString = "M"

    for point in @mediator.points
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
