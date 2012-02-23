
#= require embient/addons/sproutcore-statechart
#= require helpers/namespace
#= require helpers/statechart/state_to_string
#= require community/states/play_state
#= require community/states/build_state
#= require community/views/community_view

namespace 'community'

community.Statechart = SC.Statechart.create

  trace: YES

  rootState: SC.State.extend

    enterState: ->
      @statechart.communityView = community.views.CommunityView.create()
      Ember.run => @statechart.communityView.append()

    initialSubstate: 'Play'

    Play: community.states.PlayState
    Build: community.states.BuildState