
#= require helpers/namespace
#= require embient/ember-data
#= require vendor/raphael
#= require helpers/math/path

namespace 'shared.models'

shared.models.TrackModel = DS.Model.extend

  path: DS.attr 'string'

  pointsPath: helpers.math.Path.create()

  setPointPath: (path) ->
    @set 'pointsPath', path

    pathString = "M"

    for point in path.asPointArray()
      pathString += "#{point.x},#{point.y}L"

    pathString = pathString.substr 0, pathString.length - 1
    pathString += "Z"

    @set 'path', pathString
  
  totalLength: (Ember.computed ->
    (@get 'pointsPath').getTotalLength()
  ).property 'pointsPath'

  getPointAtLength: (length) ->
    (@get 'pointsPath').getPointAtLength length