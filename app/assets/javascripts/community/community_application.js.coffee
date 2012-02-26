
#= require helpers/namespace
#= require community/community_statechart
#= require helpers/routing/route_local_links

namespace 'community'

community.CommunityApplication = Ember.Application.extend

  ready: ->
    communityStateManager = community.CommunityStateManager.create
      application: this

    helpers.routing.routeLocalLinks communityStateManager