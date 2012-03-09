
#= require helpers/namespace
#= require embient/ember-data

namespace 'slotcars.shared'

slotcars.shared.ModelStore = DS.Store.create
  adapter: DS.RESTAdapter.create()