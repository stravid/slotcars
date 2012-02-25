
#= require helpers/namespace
#= require community/views/build_view

namespace 'community.states'

community.states.BuildState = Ember.LayoutState.create

  route: 'tracks/new'
  viewClass: community.views.BuildView

  enter: (manager) ->
    manager.set 'location', 'tracks/new'
    @_super.apply(this, arguments)