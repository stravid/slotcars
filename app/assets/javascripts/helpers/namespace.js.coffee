
@namespace = (path) ->
  namespaces = path.split '.'
  target = window
  
  for namespace, index in namespaces
    target[namespace] or= {}
    target = target[namespace]

  return target