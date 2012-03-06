
#= require helpers/namespace

namespace 'slotcars.build.controllers'

slotcars.build.controllers.DrawController = Ember.Object.extend

  track: null

  onTouchMouseMove: (point) -> @track.addPathPoint point