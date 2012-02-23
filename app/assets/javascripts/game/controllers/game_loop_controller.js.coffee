#= require helpers/request_frame
#= require helpers/namespace

namespace 'game.controllers'

@game.controllers.GameLoopController = Ember.Object.extend

  renderCallback: null

  start: (@renderCallback) ->
    @isRunning = true
    @_run()

  stop: ->
    @isRunning = false

  _run: ->
    if @isRunning
      window.requestFrame => @_run()
      @renderCallback()