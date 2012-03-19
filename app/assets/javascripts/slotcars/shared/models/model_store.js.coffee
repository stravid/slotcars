
#= require helpers/namespace
#= require embient/ember-data

#= require slotcars/shared/adapters/api_adapter

namespace 'slotcars.shared.models'

ApiAdapter = slotcars.shared.adapters.ApiAdapter

slotcars.shared.models.ModelStore = DS.Store.create
  adapter: ApiAdapter.create()
  revision: 3