
#= require helpers/namespace
#= require community/community_statechart

namespace 'community'

community.CommunityApplication = Ember.Application.extend

  ready: ->
    community.Statechart.initStatechart()