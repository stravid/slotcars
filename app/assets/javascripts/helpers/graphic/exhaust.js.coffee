
#= require helpers/namespace

namespace 'helpers.graphic'

class helpers.graphic.Exhaust
  
  paper: null
  fumes: null
  
  constructor: (@paper) ->
    @fumes = []
    
  update: ->
    index = -1
    
    for fume in @fumes
      scale = fume.scale += 0.003
      alpha = fume.alpha -= .01
      element = fume.element
      
      if alpha <= 0 
        element.remove()
        index = @fumes.indexOf(fume)
      else
        element.translate (- 1 + Math.random() * 2), (- 1 + Math.random() * 2)
        element.scale scale, scale
        element.attr 'fill', "rgba(78, 78, 78, #{alpha})"
        
    if index > -1 then @fumes.splice index, 1
    
  puff: (x, y) ->
    fume = @paper.circle(x, y, 4)
    fume.attr 'stroke', 'none'
    fume.attr 'fill', 'rgba(78, 78, 78, .4)'
    
    @fumes.push
      element: fume
      scale: 1
      alpha: 0.4
    
  @create: (paper) ->
    new Exhaust paper
