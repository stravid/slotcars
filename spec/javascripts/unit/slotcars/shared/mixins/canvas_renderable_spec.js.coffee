describe 'Shared.CanvasRenderable', ->

  it 'should always require scaledOffset', ->
    # Ember.required() just works/fires when the mixin is applied after creation
    (expect => Play.CanvasRenderable.apply Ember.Object.create()).toThrow()

  beforeEach ->
    @canvasRenderable = Shared.CanvasRenderable.apply Ember.Object.create scaledOffset: 0

  describe 'hooking into track view rendering process', ->

    beforeEach ->
      @canvasRenderable._super = sinon.spy()
      sinon.stub @canvasRenderable, 'renderAsCanvas'

    it 'should render the track view as canvas after it was inserted into DOM', ->
      @canvasRenderable.didInsertElement()

      (expect @canvasRenderable.renderAsCanvas).toHaveBeenCalled()

    it 'should call super method on its host', ->
      @canvasRenderable.didInsertElement()

      (expect @canvasRenderable._super).toHaveBeenCalled()

  describe 'rendering as canvas', ->

    beforeEach ->
      sinon.stub @canvasRenderable, 'createRenderCanvas'
      sinon.stub @canvasRenderable, 'renderTrack'

    it 'should create render canvas', ->
      @canvasRenderable.renderAsCanvas()

      (expect @canvasRenderable.createRenderCanvas).toHaveBeenCalled()

    it 'should render track', ->
      @canvasRenderable.renderAsCanvas()

      (expect @canvasRenderable.renderTrack).toHaveBeenCalled()

  describe 'creating render canvas', ->

    it 'should create a canvas dom element with jquery and save it as property', ->
      @canvasRenderable.createRenderCanvas()

      (expect @canvasRenderable.renderCanvas).toBe 'canvas' #jquery selector


  describe 'rendering the track', ->

    beforeEach ->
      @elementHtmlStub = sinon.stub()
      @canvasRenderable.$ = sinon.stub().returns html: @elementHtmlStub
      @canvasRenderable.renderCanvas = get: sinon.stub()
      sinon.stub @canvasRenderable, 'renderTrackCallback'

      sinon.stub window, 'canvg'

    afterEach -> window.canvg.restore()

    it 'should tell canvg to render the svg markup to the render canvas', ->
      testMarkup = '<svg>bla</svg>'
      @elementHtmlStub.returns testMarkup

      testCanvas = {}
      @canvasRenderable.renderCanvas.get.withArgs(0).returns testCanvas

      @canvasRenderable.renderTrack()

      (expect window.canvg).toHaveBeenCalledWith testCanvas, testMarkup

    it 'should provide render callback to canvg', ->
      @canvasRenderable.renderTrack()

      configParam = canvg.args[0][2] # last param is configuration
      configParam.renderCallback()

      (expect @canvasRenderable.renderTrackCallback).toHaveBeenCalled()


  describe 'render track callback', ->

    beforeEach ->
      sinon.stub @canvasRenderable, 'didRenderTrack'
      sinon.stub @canvasRenderable, 'replacePaperWithCanvas'

    it 'should provide hook for other mixins after track was rendered', ->
      @canvasRenderable.renderTrackCallback()

      (expect @canvasRenderable.didRenderTrack).toHaveBeenCalled()

    it 'should replace the raphael paper with the rendered canvas', ->
      @canvasRenderable.renderTrackCallback()

      (expect @canvasRenderable.replacePaperWithCanvas).toHaveBeenCalled()


  describe 'replacing raphael paper with canvas', ->

    beforeEach ->
      sinon.stub @canvasRenderable, 'removePaperAndElements'
      @elementAppendStub = sinon.stub()
      @canvasRenderable.$ = sinon.stub().returns append: @elementAppendStub

    it 'should remove the raphael paper and its elements', ->
      @canvasRenderable.replacePaperWithCanvas()

      (expect @canvasRenderable.removePaperAndElements).toHaveBeenCalled()

    it 'should append the rendered canvas to the view element', ->
      testCanvas = {}
      @canvasRenderable.renderCanvas = testCanvas

      @canvasRenderable.replacePaperWithCanvas()

      (expect @elementAppendStub).toHaveBeenCalledWith testCanvas


  describe 'removing paper and elements', ->

    beforeEach ->
      @paperFake = remove: sinon.spy()
      @canvasRenderable._paper = @paperFake
      @canvasRenderable._displayedRaphaelElements = length: 9

    it 'should remove the paper and set it to null', ->
      @canvasRenderable.removePaperAndElements()

      (expect @paperFake.remove).toHaveBeenCalled()
      (expect @canvasRenderable._paper).toBe null

    it 'should empty the displayed raphael elements array', ->
      @canvasRenderable.removePaperAndElements()

      (expect @canvasRenderable._displayedRaphaelElements.length).toBe 0
