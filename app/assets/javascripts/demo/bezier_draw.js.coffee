#= require helpers/namespace
#= require vendor/raphael
#= helpers/event_normalize

namespace 'demo'

class demo.BezierDraw
  
  @background = null
  @path = null
  @paper = null
  @anchors = null
  
  constructor: ->
    @setup()
    @addListeners()

  setup: ->
    @anchors = []
    @lines = []
    
    @paper = Raphael document.body, 1024, 768
    
    @background = @paper.rect 0, 0, 1024, 768
    @background.attr 'fill', '#BBB'
  
  addListeners: ->
   @background.click (event) => @onTouchMouseDown(event)
    
  onTouchMouseDown: (event) ->
    circle = @paper.circle event.pageX, event.pageY, 10
    circle.drag ((dx, dy, x, y, event) => @onCircleMove(dx, dy, x, y, event, circle)), @onStart , @onEnd
    circle.attr 'fill', '#000'
    
    @addPoint circle
  
  onStart: (x, y, event)->
    
    
  onEnd: (x, y, event)->
    
  
  onCircleMove: (dx, dy, x, y, event, circle) ->
    circle.attr 'cx', x
    circle.attr 'cy', y
    
    @drawPath()
  
  addPoint: (circle) ->
    @anchors.push 
      circle: circle
      anchor: null

    length = @anchors.length;
    if length > 1
      @anchors[length - 1].anchor = @createAnchorFor circle, @anchors[length - 2].circle
    
    @drawPath()
  
  drawPath: ->
    @path.remove() if @path
    @removeLines()
    
    string = ""
       
    for object, i in @anchors
      if i > 0
        from = 
          x: @anchors[i - 1].circle.attr('cx')
          y: @anchors[i - 1].circle.attr('cy')
          
        current = 
          x: object.anchor.attr('cx')
          y: object.anchor.attr('cy')
          
        to = 
          x: object.circle.attr('cx')
          y: object.circle.attr('cy')
          
        line = @paper.path "M#{from.x},#{from.y}L#{current.x},#{current.y}L#{to.x},#{to.y}"
        line.attr 'stroke', '#944'
        
        @lines.push line
    
    for point, i in @anchors
      
      if i is 0
        string = "M#{point.circle.attr('cx')},#{point.circle.attr('cy')}"
      else
        string += ','
        string += "Q#{point.anchor.attr('cx')},#{point.anchor.attr('cy')},#{point.circle.attr('cx')},#{point.circle.attr('cy')}+"
    
    
    @path = @paper.path string
    @path.attr 'stroke-width', '3' 
  
  removeLines: ->
    for line in @lines
      line.remove()
    
    @lines = []
  
  createAnchorFor: (circle, referenceCircle, index) ->
    anchor = 
      x: circle.attr('cx') + (referenceCircle.attr('cx') - circle.attr('cx')) / 2
      y: circle.attr('cy') + (referenceCircle.attr('cy') - circle.attr('cy')) / 2
    
    circle = @paper.circle anchor.x, anchor.y, 5
    circle.drag ((dx, dy, x, y, event) => @onCircleMove(dx, dy, x, y, event, circle)), @onStart , @onEnd
    circle.attr 'fill', '#000'
    
    return circle

  @create: ->
    new BezierDraw()

