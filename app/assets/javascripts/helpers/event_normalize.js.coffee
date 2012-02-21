
BEGIN_EVENT = 'touchMouseDown'
END_EVENT = 'touchMouseUp'

_document = $ document

onMouseDown = (event) ->
  event.preventDefault();
  _document.trigger createEvent(BEGIN_EVENT, event.pageX, event.pageY) 
  
onMouseUp = (event) ->
  event.preventDefault();
  _document.trigger createEvent(END_EVENT, null, null)
  
onTouchStart = (event) ->
  event.preventDefault();
  
  touch = event.originalEvent.touches[0]
  _document.trigger createEvent(BEGIN_EVENT, touch.pageX, touch.pageY)
  
onTouchEnd = (event) ->
  event.preventDefault();
  _document.trigger createEvent(END_EVENT, null, null)

createEvent = (type, x, y) ->
  jQuery.Event type, 
    target: document
    pageX: x
    pageY: y

_document.bind 'mousedown', onMouseDown
_document.bind 'mouseup', onMouseUp
_document.bind 'touchstart', onTouchStart
_document.bind 'touchend', onTouchEnd

