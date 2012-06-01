
describe 'Play.Finishable', ->

  beforeEach ->
    @trackMock = {}
    @finishable = Ember.Object.extend(Play.Finishable).create
      track: @trackMock

  describe 'hooking into canvas render pipeline after track was rendered', ->

    beforeEach ->
      @finishable._super = sinon.spy()
      sinon.stub @finishable, 'createFinishLineImage'
      sinon.stub @finishable, 'loadFinishLineImage'

    it 'should call super', ->
      @finishable.didRenderTrack()

      (expect @finishable._super).toHaveBeenCalled()
      
    it 'should create the headline image', ->
      @finishable.didRenderTrack()
      
      (expect @finishable.createFinishLineImage).toHaveBeenCalled()

    it 'should start loading the finish line image', ->
      @finishable.didRenderTrack()

      (expect @finishable.loadFinishLineImage).toHaveBeenCalled()


  describe 'creating the finish line image', ->

    it 'should create a image via javascript and save it as property', ->
      @finishable.createFinishLineImage()

      (expect (@finishable.get 'finishLineImage') instanceof Image).toBe true


  describe 'loading the finish line image', ->

    beforeEach ->
      sinon.stub @finishable, 'drawFinishLine'
      @fakeImage = onload: sinon.spy(), src: null
      @finishable.finishLineImage = @fakeImage

    it 'should define an image onload callback that draws the finish line', ->
      @finishable.loadFinishLineImage()

      @fakeImage.onload()

      (expect @finishable.drawFinishLine).toHaveBeenCalled()

    it 'should set the source of the image to load it', ->
      @finishable.loadFinishLineImage()

      (expect @fakeImage.src).toBeDefined()