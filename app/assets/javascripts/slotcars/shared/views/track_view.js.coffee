
#= require helpers/namespace
#= require vendor/raphael

namespace 'slotcars.shared.views'

slotcars.shared.views.TrackView = Ember.View.extend

  elementId: 'track-view'
  _paper: null

  ROAD_WIDTH: 70
  SIDE_WIDTH: 10
  DASH_WIDTH: 2
  SIDE_DASH_WIDTH: 3
  SIDE_WIDTH: 5

  didInsertElement: ->
    @_paper = Raphael @$()[0], 1024, 768
    
  drawTrack: ->
    @path = @track.get 'raphaelPath'

    @_drawLawn()
    @_drawOutterBase()
    @_drawOutterDash()
    @_drawOutterAsphalt()
    @_drawSideLine()
    @_drawAsphalt()
    @_drawDashedLine()
        
  _drawLawn: ->
    rect = @_paper.rect 0, 0, 1024, 768
    rect.attr 'fill', '#104c08'
  
  _drawOutterBase: ->
    path = @_paper.path @path;
    path.attr 'stroke', '#960808'
    path.attr 'stroke-width', @ROAD_WIDTH + @SIDE_DASH_WIDTH * 2 + @SIDE_WIDTH * 2 + 10
  
  _drawOutterDash: ->
    path = @_paper.path @path;
    path.attr 'stroke', '#FFFFFF'
    path.attr 'stroke-width', @ROAD_WIDTH + @SIDE_DASH_WIDTH * 2 + @SIDE_WIDTH * 2 + 10
    path.attr 'stroke-dasharray', 'mattie'
  
  _drawOutterAsphalt: ->
    path = @_paper.path @path;
    path.attr 'stroke', '#171717'
    path.attr 'stroke-width', @ROAD_WIDTH + @SIDE_DASH_WIDTH * 2 + @SIDE_WIDTH * 2 - 2
  
  _drawSideLine: ->
    path = @_paper.path @path;
    path.attr 'stroke', '#FFFFFF'
    path.attr 'stroke-width', @ROAD_WIDTH + @SIDE_DASH_WIDTH * 2
  
  _drawAsphalt: ->
    path = @_paper.path @path;
    path.attr 'stroke', '#171717'
    path.attr 'stroke-width', @ROAD_WIDTH
    
  _drawDashedLine: ->
    path = @_paper.path @path;
    path.attr 'stroke', '#FFFFFF'
    path.attr 'stroke-width', @DASH_WIDTH
    path.attr 'stroke-dasharray', '- '
    path.attr 'stroke-linecap', 'square'