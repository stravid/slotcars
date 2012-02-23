
#= require embient/addons/sproutcore-statechart

#= require helpers/namespace
#= require helpers/statechart/state_to_string

#= require community/states/play_state
#= require community/states/build_state
#= require community/views/community_view

namespace 'community'

community.Statechart = SC.Statechart.create

  rootState: SC.State.extend

    enterState: ->
      SC.routes.set 'wantsHistory', true
      SC.routes.set 'baseURI', 'http://localhost:3000'
      @statechart.communityView = community.views.CommunityView.create()
      Ember.run => @statechart.communityView.append()

    initialSubstate: 'Play'

    Play: community.states.PlayState
    Build: community.states.BuildState