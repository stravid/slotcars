Shared.Animatable = Ember.Mixin.create

  animation: null
  view: Ember.required()

  append: ->
    # overrides `didInsertElement` of the view to plug-in the animation
    @view.didInsertElement = => @animateIn() if @animateIn

    @_super()

  animate: (options, fn, callback=->) ->
    @animation = Shared.Animation.create(
      options: options
      fn: fn
      callback: callback
    ).run()

  # animateIn: ->
  #   @view.$().hide()
  #   @animate
  #     duration: 500
  #     , => @view.$().delay(500).fadeIn 500
  #     , => console.log 'animateIn - finished'

  # animateOut: ->
  #   @animate
  #     duration: 500
  #     , => @view.$().fadeOut 500
  #     , => console.log 'animateOut - finished'

  destroy: ->
    if @animateOut
      @animateOut()
      delay = (@animation.options.duration || 0) + (@animation.options.delay || 0)
      Ember.run.later (=>
        @_super.apply(@)
        @animation.destroy()
      ), delay
    else
      @_super()
