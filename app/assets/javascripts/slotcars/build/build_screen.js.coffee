
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

Builder = slotcars.build.Builder
BuildScreenView = slotcars.build.views.BuildScreenView
ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable

BuildScreen = (namespace 'slotcars.build').BuildScreen = Ember.Object.extend Appendable,

  _builder: null

  init: ->
    @view = BuildScreenView.create()

    @_builder = Builder.create
      buildScreenView: @view

  destroy: ->
    @_super()
    @_builder.destroy()

  toString: -> '<Instance of slotcars.build.BuildScreen>'


ScreenFactory.getInstance().registerScreen 'BuildScreen', BuildScreen
