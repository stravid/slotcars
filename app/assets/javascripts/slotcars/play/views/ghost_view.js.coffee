Play.GhostView = Ember.View.extend

  ghost: null
  car: null

  templateName: 'slotcars_play_templates_ghost_view_template'
  elementId: 'ghost'

  didInsertElement: -> @hide()

  hide: -> @$().hide()

  show: ->
    @$().show()
    @$().css '-webkit-transform', "rotateZ(#{@car.rotation}deg)"
    @$().css '-moz-transform', "rotateZ(#{@car.rotation}deg)"
    @$().css '-o-transform', "rotate(#{@car.rotation}deg)"

  update: (->
    rotation = @ghost.rotation
    position = @ghost.get 'position'

    drawPosition =
      x: (position.x - @car.position.x) * 2
      y: (position.y - @car.position.y) * 2

    @$().css '-webkit-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    @$().css '-moz-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    @$().css '-o-transform', "translate(#{drawPosition.x}px,#{drawPosition.y}px)rotate(#{rotation}deg)"
  ).observes 'ghost.position'
