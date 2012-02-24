
BEGIN_EVENT = 'touchMouseDown'
END_EVENT = 'touchMouseUp'
MOVE_EVENT = 'touchMouseMove'

jQueryDocument = jQuery document

onMouseDown = (event) ->
  jQueryDocument.on 'mousemove', onMouseMove

  event.preventDefault()
  jQueryDocument.trigger (createEvent BEGIN_EVENT, event.pageX, event.pageY)
  
onMouseUp = (event) ->
  jQueryDocument.off 'mousemove', onMouseMove

  event.preventDefault()
  jQueryDocument.trigger (createEvent END_EVENT, null, null)

onMouseMove = (event) ->
  event.preventDefault()

  jQueryDocument.trigger (createEvent MOVE_EVENT, event.pageX, event.pageY)
  
onTouchStart = (event) ->
  event.preventDefault()
  
  touch = event.originalEvent.touches[0]
  jQueryDocument.trigger (createEvent BEGIN_EVENT, touch.pageX, touch.pageY)
  
onTouchEnd = (event) ->
  event.preventDefault()
  jQueryDocument.trigger (createEvent END_EVENT, null, null)

onTouchMove = (event) ->
  event.preventDefault()

  touch = event.originalEvent.touches[0]
  jQueryDocument.trigger (createEvent MOVE_EVENT, touch.pageX, touch.pageY)

createEvent = (type, x, y) ->
  jQuery.Event type, 
    target: document
    pageX: x
    pageY: y

jQueryDocument.on 'mousedown', onMouseDown
jQueryDocument.on 'mouseup', onMouseUp
jQueryDocument.on 'touchstart', onTouchStart
jQueryDocument.on 'touchend', onTouchEnd
jQueryDocument.on 'touchmove', onTouchMove
