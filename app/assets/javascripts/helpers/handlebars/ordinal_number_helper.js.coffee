Handlebars.registerHelper 'ordinal_number', (property) ->
  value = Ember.getPath this, property

  new Handlebars.SafeString Shared.ordinalNumber value