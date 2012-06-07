Play.GameLoopController = Ember.Object.extend

  renderCallback: null
  stopLoop: false

  start: (@renderCallback) ->
    @stopLoop = false

    @_run()

  _run: ->
    return if @stopLoop

    window.requestAnimationFrame => @_run()
    @renderCallback()

  destroy: ->
    @stopLoop = true
