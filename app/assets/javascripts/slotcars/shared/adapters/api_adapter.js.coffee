
#= require helpers/namespace

Shared.ApiAdapter = DS.RESTAdapter.extend

  namespace: 'api'
  bulkCommit: false