
#= require helpers/namespace
#= require embient/ember-data
#= require vendor/raphael

namespace 'shared.models'

shared.models.TrackModel = DS.Model.extend

  path: DS.attr 'string'

  setPointArray: (points) ->
    pathString = "M"

    for point in points
      pathString += "#{point.x},#{point.y}L"

    pathString = pathString.substr 0, pathString.length - 1
    pathString += "Z"

    @set 'path', pathString
  
  totalLength: (Ember.computed ->
    Raphael.getTotalLength @get 'path'
  ).property 'path'

  getPointAtLength: (length) ->
    Raphael.getPointAtLength (@get 'path'), length