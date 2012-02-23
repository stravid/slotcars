
#= require embient/addons/sproutcore-statechart
#= require helpers/namespace
#= require community/views/play_view

namespace 'community.states'

community.states.PlayState = SC.State.extend

  enterState: ->
    playView = @statechart.playView = community.views.PlayView.create
      coordinator: @statechart

    playView.appendTo @statechart.communityView.$()

  exitState: ->
    @statechart.playView.remove()


  build: ->
    @gotoState 'Build'
