
BEGIN_EVENT = 'touchMouseDown'
END_EVENT = 'touchMouseUp'
MOVE_EVENT = 'touchMouseMove'

jQueryDocument = jQuery document

onMouseDown = (event) ->
  jQueryDocument.on 'mousemove', onMouseMove

  (jQuery event.target).trigger (createEvent BEGIN_EVENT, event.pageX, event.pageY, event.target, event)
  
onMouseUp = (event) ->
  jQueryDocument.off 'mousemove', onMouseMove

  (jQuery event.target).trigger (createEvent END_EVENT, null, null, event.target, event)

onMouseMove = (event) ->
  (jQuery event.target).trigger (createEvent MOVE_EVENT, event.pageX, event.pageY, event.target, event)
  
onTouchStart = (event) ->
  touch = event.originalEvent.touches[0]
  (jQuery event.target).trigger (createEvent BEGIN_EVENT, touch.pageX, touch.pageY, event.target, event)
  
onTouchEnd = (event) ->
  (jQuery event.target).trigger (createEvent END_EVENT, null, null, event.target, event)

onTouchMove = (event) ->
  touch = event.originalEvent.touches[0]
  (jQuery event.target).trigger (createEvent MOVE_EVENT, touch.pageX, touch.pageY, event.target, event)

createEvent = (type, x, y, target, originalEvent) ->
  jQuery.Event type, 
    target: target
    originalEvent: originalEvent
    pageX: x
    pageY: y

jQueryDocument.on 'mousedown', onMouseDown
jQueryDocument.on 'mouseup', onMouseUp
jQueryDocument.on 'touchstart', onTouchStart
jQueryDocument.on 'touchend', onTouchEnd
jQueryDocument.on 'touchmove', onTouchMove
