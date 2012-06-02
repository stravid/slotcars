# can be used in handlebar templates to inspect the current context
# use like this: {{debug}} or {{debug propertyName}}

Handlebars.registerHelper "debug", (optionalValue) ->
  console.log "Current Context"
  console.log "===================="
  console.log this
 
  if optionalValue
    console.log "Value"
    console.log "===================="
    console.log optionalValue
  