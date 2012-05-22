DS.attr.transforms.json =
  from: (serialized) ->
    JSON.parse serialized

  to: (deserialized) ->
    JSON.stringify deserialized