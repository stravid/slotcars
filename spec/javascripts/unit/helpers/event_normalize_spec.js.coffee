describe 'event_normalize',  ->

  LEFT_MOUSE_BUTTON = 1

  beforeEach -> @onEventSpy = sinon.spy()

  afterEach ->
    @onEventSpy = null
    (jQuery document).off 'touchMouseUp'
    (jQuery document).off 'touchMouseDown'
    (jQuery document).off 'touchMouseMove'

  describe 'mouse event normalization', ->

    it 'should trigger touchMouseDown event on document when mousedown', ->
      value = 13

      event = jQuery.Event 'mousedown', { which: LEFT_MOUSE_BUTTON, pageX: value, pageY: 0 }

      (jQuery document).on 'touchMouseDown', @onEventSpy
      (jQuery document).trigger event

      (expect @onEventSpy).toHaveBeenCalled()
      (expect @onEventSpy.args[0][0]).toBeDefined()

      receiveEvent = @onEventSpy.args[0][0]
      (expect receiveEvent.pageX).toBe value

    it 'should trigger touchMouseUp event on document when mouseup', ->
      (jQuery document).on 'touchMouseUp', @onEventSpy
      (jQuery document).trigger jQuery.Event 'mouseup', { which: LEFT_MOUSE_BUTTON }

      (expect @onEventSpy).toHaveBeenCalled()

    it 'shoud not trigger touchMouseMove event on document when mousemove', ->
      (jQuery document).on 'touchMouseMove', @onEventSpy
      (jQuery document).trigger 'mousemove'

      (expect @onEventSpy).not.toHaveBeenCalled()

    it 'should trigger touchMouseMove event on document when a mousedown and mousemove happen', ->
      value = 42
      moveEvent = jQuery.Event 'mousemove', { pageX: value, pageY: 0 }

      (jQuery document).on 'touchMouseMove', @onEventSpy
      (jQuery document).trigger jQuery.Event 'mousedown', { which: LEFT_MOUSE_BUTTON }
      (jQuery document).trigger moveEvent

      (expect @onEventSpy).toHaveBeenCalled()
      (expect @onEventSpy.args[0][0]).toBeDefined()

      receiveEvent = @onEventSpy.args[0][0]
      (expect receiveEvent.pageX).toBe value


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

      receiveEvent = @onEventSpy.args[0][0]

      (expect receiveEvent.pageX).toBe value

    it 'should trigger touchMouseUp event on document when touchend', ->
      (jQuery document).on 'touchMouseUp', @onEventSpy
      (jQuery document).trigger 'touchend'

      (expect @onEventSpy).toHaveBeenCalled()

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
