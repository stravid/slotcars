
#= require helpers/namespace
#= require embient/ember-data

namespace 'shared'

shared.ModelStore = DS.Store.create
  adapter: DS.RESTAdapter.create()