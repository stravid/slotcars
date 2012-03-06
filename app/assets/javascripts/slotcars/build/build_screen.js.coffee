
#= require helpers/namespace
#= require slotcars/build/build_screen_state_manager
#= require slotcars/build/views/build_screen_view

namespace 'slotcars.build'

slotcars.build.BuildScreen = Ember.Object.extend
  isBuildScreen: true

  appendToApplication: ->
    slotcars.build.BuildScreenStateManager.create
      delegate: this

  appendScreen: ->
    buildScreenView = (slotcars.build.views.BuildScreenView.create delegate: this)
    buildScreenView.append()

