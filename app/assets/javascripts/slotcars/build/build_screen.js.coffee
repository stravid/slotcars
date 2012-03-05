
#= require helpers/namespace
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/controllers/builder_controller

namespace 'slotcars.build'

slotcars.build.BuildScreen = Ember.Object.extend

  _buildScreenView: null
  _builderController: null

  appendToApplication: ->
    @appendScreen()
    @setupBuilder()

  appendScreen: ->
    @_buildScreenView = slotcars.build.views.BuildScreenView.create()
    @_buildScreenView.append()

  setupBuilder: ->
    @_builderController = slotcars.build.controllers.BuilderController.create
      buildScreenView: @_buildScreenView

  destroy: ->
    @_super()
    @_buildScreenView.remove()
    @_builderController.destroy()

  toString: -> '<Instance of slotcars.build.BuildScreen>'