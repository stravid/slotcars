
#= require helpers/namespace

namespace 'game.controllers'

@game.controllers.GameLoopController = Ember.Object.extend

  renderCallback: null

  # provides _run as always bound to this object
  _proxyRun: null

  init: ->
    @_proxyRun = $.proxy @_run, this

  start: (@renderCallback) ->
    @_run()

  _run: ->
    window.webkitRequestAnimationFrame(@_proxyRun)
    @renderCallback()