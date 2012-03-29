
#= require helpers/request_frame

(namespace 'slotcars.play.controllers').GameLoopController = Ember.Object.extend

  renderCallback: null
  stopLoop: false

  start: (@renderCallback) ->
    @stopLoop = false

    @_run()

  _run: ->
    return if @stopLoop

    window.requestFrame => @_run()
    @renderCallback()

  destroy: ->
    @stopLoop = true
