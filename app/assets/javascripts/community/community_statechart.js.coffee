
#= require helpers/namespace
#= require embient/ember-layout
#= require embient/ember-routemanager

#= require community/states/play_state
#= require community/states/build_state
#= require community/views/community_view

namespace 'community'

community.CommunityStateManager = Ember.RouteManager.extend

  rootElement: null
  wantsHistory: true
  baseURI: window.location.origin

  start: Ember.LayoutState.create

    viewClass: community.views.CommunityView

    initialState: 'Play'

    Play: community.states.PlayState
    Build: community.states.BuildState