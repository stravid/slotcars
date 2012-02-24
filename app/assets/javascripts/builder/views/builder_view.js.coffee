#= require helpers/namespace

#= require helpers/event_normalize

namespace 'builder.views'

builder.views.BuilderView = Ember.View.extend

  elementId: 'builder-view'
  lastPointIndex: 0

  didInsertElement: ->
    (jQuery document).on 'touchMouseMove', (event) => @_onTouchMouseMove(event)

    @intervalId = setInterval (=> @_draw()), 1000 / 20

  _onTouchMouseMove: (event) ->
    @controller.onTouchMouseMove { x: event.pageX, y: event.pageY }

  _draw: ->
    length = @mediator.points.length
    points = @mediator.points

    return if @lastPointIndex is length

    for i in [@lastPointIndex...length]
      @paper.circle points[i].x, points[i].y, 0.5

    @lastPointIndex = length - 1