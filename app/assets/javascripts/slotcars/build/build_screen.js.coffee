
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/shared/lib/appendable

Builder = slotcars.build.Builder
BuildScreenView = slotcars.build.views.BuildScreenView
Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.build').BuildScreen = Ember.Object.extend Appendable,

  _builder: null

  appendToApplication: ->
    @_appendScreen()
    @_setupBuilder()

  _appendScreen: ->
    @view = BuildScreenView.create()
    @appendView()

  _setupBuilder: ->
    @_builder = Builder.create
      buildScreenView: @view

  destroy: ->
    @_super()
    @_builder.destroy()

  toString: -> '<Instance of slotcars.build.BuildScreen>'