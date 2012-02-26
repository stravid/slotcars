
#= require helpers/namespace
#= require embient/ember-layout
#= require embient/ember-routemanager

#= require community/views/play_view
#= require community/views/build_view
#= require community/views/community_view

namespace 'community'

community.CommunityStateManager = Ember.RouteManager.extend

  rootElement: null
  wantsHistory: true
  baseURI: window.location.origin

  locationInitialized: (->
    if (Ember.empty @get 'location') then (@set 'location', 'tracks/new')
  ).observes 'location'

  start: Ember.LayoutState.create

    viewClass: community.views.CommunityView

    Tracks: Ember.State.create

      route: 'tracks'

      New: Ember.LayoutState.create
        route: 'new'

        viewClass: community.views.BuildView

      Show: Ember.LayoutState.create
        route: ':id'

        viewClass: community.views.PlayView