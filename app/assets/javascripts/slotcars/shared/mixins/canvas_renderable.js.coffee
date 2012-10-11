Shared.CanvasRenderable = Ember.Mixin.create

  renderCanvas: null
  scaledOffset: Ember.required()

  didInsertElement: ->
    @_super()
    @renderAsCanvas()

  renderAsCanvas: ->
    @createRenderCanvas()
    @renderTrack()

  createRenderCanvas: -> @set 'renderCanvas', jQuery "<canvas>"

  renderTrack: ->
    svgMarkup = @$().html()

    canvg @renderCanvas.get(0), svgMarkup,
      renderCallback: => @renderTrackCallback()
      ignoreMouse: true
      ignoreAnimation: true
      ignoreClear: true

  renderTrackCallback: ->
    @didRenderTrack()
    @replacePaperWithCanvas()

  # can be used by other mixins to hook in before the canvas is displayed
  didRenderTrack: ->
    @renderCanvas.css position: 'relative', top: - @scaledOffset, left: - @scaledOffset

  replacePaperWithCanvas: ->
    @removePaperAndElements()
    @$().append @renderCanvas

  removePaperAndElements: ->
    @_paper.remove()
    @_paper = null

    # clear array cleanly
    @_displayedRaphaelElements.length = 0
