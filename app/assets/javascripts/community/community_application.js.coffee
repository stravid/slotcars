
#= require helpers/namespace
#= require community/community_statechart
#= require helpers/routing/route_local_links

#= require demo/bezier_draw

namespace 'community'

community.CommunityApplication = Ember.Application.extend

  ready: ->
    
    # = HOOK FOR DEMO =
    
    demo.BezierDraw.create();
    
    return;
    
    # =================
    
    communityStateManager = community.CommunityStateManager.create
      application: this

    helpers.routing.routeLocalLinks communityStateManager