
#= require helpers/event_normalize

describe 'event_normalize',  ->
  
  beforeEach ->
    @onEventSpy = sinon.spy()
    
  afterEach ->
    @onEventSpy = null;
  
  describe 'mouse event normalization', ->
  
    it 'should trigger touchMouseDown event on document when mousedown', ->
      
      value = 13
      
      event = jQuery.Event 'mousedown', {pageX: value, pageY: 0}
      
      ($ document).bind 'touchMouseDown', @onEventSpy
      ($ document).trigger event
      
      (expect @onEventSpy).toHaveBeenCalled();
      (expect @onEventSpy.args[0][0]).toBeDefined();
      
      receiveEvent = @onEventSpy.args[0][0]
      (expect receiveEvent.pageX).toBe value
      
    it 'should trigger touchMouseUp event on document when mouseup', ->
      
      ($ document).bind 'touchMouseUp', @onEventSpy
      ($ document).trigger 'mouseup'
      
      (expect @onEventSpy).toHaveBeenCalled();
      
  describe 'touch event normalization', ->
    
    it 'should trigger touchMouseDown event on document when touchstart', ->
      value = 10
    
      event = jQuery.Event 'touchstart', 
        originalEvent: 
          touches: [ {pageX: value, pageY: 0} ]
    
      ($ document).bind 'touchMouseDown', @onEventSpy
      ($ document).trigger event
      
      (expect @onEventSpy).toHaveBeenCalled();
      (expect @onEventSpy.args[0][0]).toBeDefined()
      
      receiveEvent = @onEventSpy.args[0][0]
      
      (expect receiveEvent.pageX).toBe value
    
    it 'should trigger touchMouseUp event on document when touchend', ->
    
      ($ document).bind 'touchMouseUp', @onEventSpy
      ($ document).trigger 'touchend' 
      
      (expect @onEventSpy).toHaveBeenCalled(); 


