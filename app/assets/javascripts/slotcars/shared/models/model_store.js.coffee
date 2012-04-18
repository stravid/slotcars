
#= require embient/ember-data
#= require slotcars/shared/adapters/api_adapter

ApiAdapter = slotcars.shared.adapters.ApiAdapter

(namespace 'slotcars.shared.models').ModelStore = DS.Store.create

  adapter: ApiAdapter.create()
  revision: 4
