#= require helpers/request_frame
#= require helpers/namespace

namespace 'slotcars.play.controllers'

slotcars.play.controllers.GameLoopController = Ember.Object.extend

  renderCallback: null

  start: (@renderCallback) ->
    @_run()

  _run: ->
    window.requestFrame => @_run()
    @renderCallback()