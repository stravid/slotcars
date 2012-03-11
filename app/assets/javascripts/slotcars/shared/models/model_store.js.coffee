
#= require helpers/namespace
#= require embient/ember-data

namespace 'slotcars.shared.models'

slotcars.shared.models.ModelStore = DS.Store.create
  adapter: DS.RESTAdapter.create()