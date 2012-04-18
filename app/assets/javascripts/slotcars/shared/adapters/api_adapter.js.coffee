
#= require helpers/namespace

namespace 'slotcars.shared.adapters'

slotcars.shared.adapters.ApiAdapter = DS.RESTAdapter.extend

  namespace: 'api'
  bulkCommit: false