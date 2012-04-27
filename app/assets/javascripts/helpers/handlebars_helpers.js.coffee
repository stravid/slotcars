Handlebars.registerHelper 'racetime', (property) ->
  value = Ember.getPath this, property

  new Handlebars.SafeString Shared.racetimeString value