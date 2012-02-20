
#= require helpers/event_normalize

describe 'event_normalize',  ->
  
  it 'document should recieve touchMouseDown event on mousedown', ->
    
    onTouchMouseDownSpy = sinon.spy()
    
    ($ document).bind 'touchMouseDown', onTouchMouseDownSpy
    ($ document).trigger 'mousedown' 
    
    (expect onTouchMouseDownSpy.calledOnce).toBe true
    
  it 'document should recieve touchMouseUp event on mouseup', ->
    
    onTouchMouseUpSpy = sinon.spy()
    
    ($ document).bind 'touchMouseUp', onTouchMouseUpSpy
    ($ document).trigger 'mouseup'
    
    (expect onTouchMouseUpSpy.calledOnce).toBe true
    