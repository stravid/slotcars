
#= require helpers/namespace
#= require embient/ember-data
#= require helpers/math/path

namespace 'slotcars.shared.models'

slotcars.shared.models.TrackModel = DS.Model.extend

  _path: null

  init: ->
    @_super()
    @_path = helpers.math.Path.create()

  addPathPoint: (point) -> @_path.push point, true