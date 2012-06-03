
BEGIN_EVENT = 'touchMouseDown'
END_EVENT = 'touchMouseUp'
MOVE_EVENT = 'touchMouseMove'

LEFT_MOUSE_BUTTON = 1

jQueryDocument = jQuery document

onMouseDown = (event) ->
  return unless event.which is LEFT_MOUSE_BUTTON
  
  jQueryDocument.on 'mousemove', onMouseMove
  
  (jQuery event.target).trigger (createEvent BEGIN_EVENT, event.pageX, event.pageY, event)
  
onMouseUp = (event) ->
  return unless event.which is LEFT_MOUSE_BUTTON
  
  jQueryDocument.off 'mousemove', onMouseMove

  (jQuery event.target).trigger (createEvent END_EVENT, null, null, event)

onMouseMove = (event) ->
  (jQuery event.target).trigger (createEvent MOVE_EVENT, event.pageX, event.pageY, event)
  
onTouchStart = (event) ->
  touch = event.originalEvent.touches[0]
  (jQuery event.target).trigger (createEvent BEGIN_EVENT, touch.pageX, touch.pageY, event)
  
onTouchEnd = (event) ->
  (jQuery event.target).trigger (createEvent END_EVENT, null, null, event)

onTouchMove = (event) ->
  touch = event.originalEvent.touches[0]
  (jQuery event.target).trigger (createEvent MOVE_EVENT, touch.pageX, touch.pageY, event)

createEvent = (type, x, y, originalEvent) ->
  jQuery.Event type, 
    originalEvent: originalEvent
    pageX: x
    pageY: y

jQueryDocument.on 'mousedown', onMouseDown
jQueryDocument.on 'mouseup', onMouseUp
jQueryDocument.on 'touchstart', onTouchStart
jQueryDocument.on 'touchend', onTouchEnd
jQueryDocument.on 'touchmove', onTouchMove
