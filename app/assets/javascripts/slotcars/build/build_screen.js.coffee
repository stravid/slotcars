
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/shared/lib/appendable

Builder = slotcars.build.Builder
Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.build').BuildScreen = Ember.Object.extend Appendable,

  _builder: null

  appendToApplication: ->
    @_appendScreen()
    @_setupBuilder()

  _appendScreen: ->
    @view = slotcars.build.views.BuildScreenView.create()
    @appendView()

  _setupBuilder: ->
    @_builder = Builder.create
      buildScreenView: @view

  destroy: ->
    @_super()
    @_builder.destroy()
    @removeView()

  toString: -> '<Instance of slotcars.build.BuildScreen>'