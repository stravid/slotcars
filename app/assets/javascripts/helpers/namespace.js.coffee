
@namespace = (path) ->
  namespaces = path.split '.'
  target = window
  
  for namespace in namespaces
    target[namespace] or= {} 
    target = target[namespace]