
BEGIN_EVENT = 'touchMouseDown'
END_EVENT = 'touchMouseUp'

jQueryDocument = $ document

onMouseDown = (event) ->
  event.preventDefault()
  jQueryDocument.trigger createEvent(BEGIN_EVENT, event.pageX, event.pageY) 
  
onMouseUp = (event) ->
  event.preventDefault()
  jQueryDocument.trigger createEvent(END_EVENT, null, null)
  
onTouchStart = (event) ->
  event.preventDefault()
  
  touch = event.originalEvent.touches[0]
  jQueryDocument.trigger createEvent(BEGIN_EVENT, touch.pageX, touch.pageY)
  
onTouchEnd = (event) ->
  event.preventDefault()
  jQueryDocument.trigger createEvent(END_EVENT, null, null)

createEvent = (type, x, y) ->
  jQuery.Event type, 
    target: document
    pageX: x
    pageY: y

jQueryDocument.on 'mousedown', onMouseDown
jQueryDocument.on 'mouseup', onMouseUp
jQueryDocument.on 'touchstart', onTouchStart
jQueryDocument.on 'touchend', onTouchEnd
