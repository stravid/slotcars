
#= require helpers/namespace
#= require slotcars/build/build_screen_state_manager

namespace 'slotcars.build'

slotcars.build.BuildScreen = Ember.Object.extend
  isBuildScreen: true

  init: ->
    slotcars.build.BuildScreenStateManager.create
      delegate: this
