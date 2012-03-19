
#= require helpers/namespace

namespace 'slotcars.shared.adapters'

slotcars.shared.adapters.ApiAdapter = DS.Adapter.extend
  findAll: (store, type) ->
    hash =
      url: type.url
      dataType: 'json'
      contentType: 'application/json'
      success: (json) -> store.loadMany type, json

    jQuery.ajax hash
