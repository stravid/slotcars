Play.GhostView = Ember.View.extend

  ghost: null
  car: null

  templateName: 'slotcars_play_templates_ghost_view_template'
  tagName: ''

  didInsertElement: ->
    @_super()
    @hide()

  hide: -> @$('#ghost').hide()

  show: ->
    @$('#ghost').show()
    @$('#ghost').css '-webkit-backface-visibility', 'hidden'
    @$('#ghost').css '-webkit-transform', "rotateZ(#{@car.rotation}deg)"

  update: (->
    rotation = @ghost.rotation
    position = @ghost.get 'position'

    drawPosition =
      x: (position.x - @car.position.x) * 2
      y: (position.y - @car.position.y) * 2

    (jQuery '#ghost').css '-webkit-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
  ).observes 'ghost.position'
