Shared.Animatable = Ember.Mixin.create

  animation: null
  view: Ember.required()

  append: ->
    originalDidInsertElementMethod = @view.didInsertElement

    @view.didInsertElement = =>
      @animateIn() if @animateIn
      originalDidInsertElementMethod() if originalDidInsertElementMethod

    @_super()

  animate: (options, fn, callback=->) ->
    @animation = Shared.Animation.create(
      options: options
      fn: fn
      callback: callback
    ).run()

  animateIn: ->
    @view.$().css({ top: 3, opacity: 0 })
    @animate { delay: 350 }
      , => @view.$().animate { top: '-=3', opacity: 1 }, { duration: 300 }

  animateOut: ->
    @animate { duration: 450 }
      , => @view.$().animate { top: '+=3', opacity: 0 }, { duration: 400 }

  destroy: ->
    if @animateOut
      @animateOut()
      _super = @_super
      delay = (@animation.options.duration || 0) + (@animation.options.delay || 0)
      Ember.run.later (=>
        _super.apply this
        @animation.destroy()
      ), delay
    else
      @_super()
