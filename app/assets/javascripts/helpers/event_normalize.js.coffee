
BEGIN_EVENT = 'touchMouseDown'
END_EVENT = 'touchMouseUp'

_document = $ document

onMouseDown = (event) ->
  _document.trigger BEGIN_EVENT
  
onMouseUp = (event) ->
  _document.trigger END_EVENT
  
  
_document.bind "mousedown", onMouseDown
_document.bind "mouseup", onMouseUp
