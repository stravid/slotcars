
#= require helpers/namespace
#= require embient/ember-layout
#= require community/views/play_view

namespace 'community.states'

community.states.PlayState = Ember.LayoutState.create

  route: 'tracks'
  viewClass: community.views.PlayView

  enter: (manager) ->
    manager.set 'location', 'tracks'
    @_super.apply(this, arguments)
