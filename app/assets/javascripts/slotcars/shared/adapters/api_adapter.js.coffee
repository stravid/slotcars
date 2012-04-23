
Shared.ApiAdapter = DS.RESTAdapter.extend

  namespace: 'api'
  bulkCommit: false

  # override RESTAdapter to handle validation errors
  createRecord: (store, type, record) ->
    root = @rootForType type

    data = {}
    data[root] = record.toJSON()

    @ajax this.buildURL(root), "POST",
      data: data,

      success: (json) ->
        @sideload(store, type, json, root)
        store.didCreateRecord(record, json[root])

      # this is the only diff to the original method
      error: (response) ->
        record.set 'validationErrors', (JSON.parse response.responseText).errors
        record.set 'hasValidationErrors', true