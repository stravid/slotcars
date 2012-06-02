# Truncates the text and adds ellipsis
Handlebars.registerHelper "truncate_with_ellipsis", (property, length) ->
  value = Ember.getPath this, property
  
  if value.length < length
    truncatedText = value
  else
    truncatedText = value.substr(0, length-3) + "&hellip;"
      
  new Handlebars.SafeString truncatedText