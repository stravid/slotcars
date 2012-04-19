describe 'event_normalize',  ->

  beforeEach ->
    @onEventSpy = sinon.spy()

  afterEach ->
    @onEventSpy = null

  describe 'mouse event normalization', ->

    it 'should trigger touchMouseDown event on document when mousedown', ->
      value = 13

      event = jQuery.Event 'mousedown', { pageX: value, pageY: 0 }

      (jQuery document).on 'touchMouseDown', @onEventSpy
      (jQuery document).trigger event

      (expect @onEventSpy).toHaveBeenCalled()
      (expect @onEventSpy.args[0][0]).toBeDefined()

      receiveEvent = @onEventSpy.args[0][0]
      (expect receiveEvent.pageX).toBe value

      (jQuery document).off 'touchMouseDown', @onEventSpy

    it 'should trigger touchMouseUp event on document when mouseup', ->
      (jQuery document).on 'touchMouseUp', @onEventSpy
      (jQuery document).trigger 'mouseup'

      (expect @onEventSpy).toHaveBeenCalled()

      (jQuery document).off 'touchMouseUp', @onEventSpy

    it 'shoud not trigger touchMouseMove event on document when mousemove', ->
      (jQuery document).on 'touchMouseMove', @onEventSpy
      (jQuery document).trigger 'mousemove'

      (expect @onEventSpy).not.toHaveBeenCalled()

      (jQuery document).off 'touchMouseMove', @onEventSpy

    it 'should trigger touchMouseMove event on document when a mousedown and mousemove happen', ->
      value = 42
      moveEvent = jQuery.Event 'mousemove', { pageX: value, pageY: 0 }

      (jQuery document).on 'touchMouseMove', @onEventSpy
      (jQuery document).trigger 'mousedown'
      (jQuery document).trigger moveEvent

      (expect @onEventSpy).toHaveBeenCalled()
      (expect @onEventSpy.args[0][0]).toBeDefined()

      receiveEvent = @onEventSpy.args[0][0]
      (expect receiveEvent.pageX).toBe value

      (jQuery document).off 'touchMouseMove', @onEventSpy


  describe 'touch event normalization', ->
    
    it 'should trigger touchMouseDown event on document when touchstart', ->
      value = 10

      event = jQuery.Event 'touchstart', 
        originalEvent: 
          touches: [ { pageX: value, pageY: 0 } ]

      (jQuery document).on 'touchMouseDown', @onEventSpy
      (jQuery document).trigger event

      (expect @onEventSpy).toHaveBeenCalled();
      (expect @onEventSpy.args[0][0]).toBeDefined()

      (jQuery document).off 'touchMouseDown', @onEventSpy

      receiveEvent = @onEventSpy.args[0][0]

      (expect receiveEvent.pageX).toBe value

    it 'should trigger touchMouseUp event on document when touchend', ->
      (jQuery document).on 'touchMouseUp', @onEventSpy
      (jQuery document).trigger 'touchend'

      (expect @onEventSpy).toHaveBeenCalled()

      (jQuery document).off 'touchMouseUp', @onEventSpy

    it 'should trigger touchMouseMove event on document when touchmove', ->
      value = 42

      moveEvent = jQuery.Event 'touchmove',
        originalEvent:
          touches: [ { pageX: value, pageY: 0 } ]

      (jQuery document).on 'touchMouseMove', @onEventSpy
      (jQuery document).trigger moveEvent

      (expect @onEventSpy).toHaveBeenCalled();
      (expect @onEventSpy.args[0][0]).toBeDefined()

      receiveEvent = @onEventSpy.args[0][0]

      (expect receiveEvent.pageX).toBe value

      (jQuery document).off 'touchMouseMove', @onEventSpy
