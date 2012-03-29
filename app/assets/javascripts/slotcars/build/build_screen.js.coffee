
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/factories/screen_factory

Builder = slotcars.build.Builder
ScreenFactory = slotcars.factories.ScreenFactory

BuildScreen = (namespace 'slotcars.build').BuildScreen = Ember.Object.extend

  _buildScreenView: null
  _builder: null

  appendToApplication: ->
    @appendScreen()
    @setupBuilder()

  appendScreen: ->
    @_buildScreenView = slotcars.build.views.BuildScreenView.create()
    @_buildScreenView.append()

  setupBuilder: ->
    @_builder = Builder.create
      buildScreenView: @_buildScreenView

  destroy: ->
    @_super()
    @_builder.destroy()
    @_buildScreenView.remove()

  toString: -> '<Instance of slotcars.build.BuildScreen>'


ScreenFactory.get().registerScreen 'BuildScreen', BuildScreen