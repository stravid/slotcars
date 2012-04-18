
#= require embient/ember-data
#= require slotcars/shared/adapters/api_adapter

Shared.ModelStore = DS.Store.create
  adapter: Shared.ApiAdapter.create()
  revision: 3
