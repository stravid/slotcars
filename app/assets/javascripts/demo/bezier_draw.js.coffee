#= require helpers/namespace
#= require vendor/raphael
#= helpers/event_normalize

namespace 'demo'

class demo.BezierDraw
  
  @path = null
  @paper = null
  @anchors = null
  
  constructor: ->
    @setup()
    @addListeners()

  setup: ->
    @anchors = []
    @paper = Raphael document.body, 1024, 768
  
  addListeners: ->
    (jQuery document).on "touchMouseDown", (event) => @onMouseDown(event)
    
  onMouseDown: (event) ->
    event.originalEvent.preventDefault()
    
    point = 
      x: event.pageX
      y: event.pageY
    
    @addPoint point
    
  addPoint: (point) ->
    @anchors.push point
    string = ""
      
    for point, i in @anchors
      
      if i is 0
        string = @pathString point, 'M'
      else
        string += ','
        string += @pathString point, 'L'
    
    @paper.circle point.x, point.y, 5
    @drawPath string
  
  pathString: (point, type) ->
    "#{type}#{point.x},#{point.y}"
  
  drawPath: (string) ->
    @path.remove if @path
    @path = @paper.path string    
  

  @create: ->
    new BezierDraw()

