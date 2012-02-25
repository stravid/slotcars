#= require helpers/namespace

#= require helpers/event_normalize

namespace 'builder.views'

builder.views.BuilderView = Ember.View.extend

  elementId: 'builder-view'
  lastPointIndex: 0
  builderController: null
  intervalId: null
  paper: null

  didInsertElement: ->
    (jQuery document).on 'touchMouseMove', (event) => @_onTouchMouseMove(event)
    (jQuery document).on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  _onTouchMouseMove: (event) ->
    x = event.pageX
    y = event.pageY

    @builderController.onTouchMouseMove { x: x, y: y }
    @_drawPoint x, y

  _onTouchMouseUp: (event) ->
    @builderController.onTouchMouseUp event
    @_redraw()

  _redraw: ->
    @paper.clear()

    length = @mediator.points.length
    points = @mediator.points

    for point in points
      @_drawPoint point.x, point.y

  _drawPoint: (x, y)->
    offset = (jQuery '#builder-application').offset()
    if offset?
      x -= offset.left
      y -= offset.top
    @paper.circle x, y, 0.5