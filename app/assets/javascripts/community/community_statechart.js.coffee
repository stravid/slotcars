
#= require helpers/namespace
#= require embient/ember-routemanager

#= require community/views/community_view
#= require community/states/tracks/tracks_new_state
#= require community/states/tracks/tracks_show_state

namespace 'community'

community.CommunityStateManager = Ember.RouteManager.extend

  wantsHistory: true
  baseURI: window.location?.origin? || ( window.location.protocol + "//" + window.location.host )
  application: null

  # builder is default state
  redirectToRootState: (->
    if (Ember.empty @get 'location') then (@set 'location', 'tracks/new')
  ).observes 'location'

  start: Ember.State.create

    enter: (manager) ->
      manager.communityView = community.views.CommunityView.create()
      manager.communityView.appendTo (jQuery manager.application.rootElement)

    Tracks: Ember.State.create

      route: 'tracks'

      New: community.states.tracks.TracksNewState
      Show: community.states.tracks.TracksShowState