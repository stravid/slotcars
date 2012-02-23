
#= require embient/addons/sproutcore-statechart
#= require helpers/namespace
#= require community/views/build_view

namespace 'community.states'

community.states.BuildState = SC.State.extend

  representRoute: 'tracks/new'

  enterState: ->
    SC.routes.set 'location', 'tracks/new'

    buildView = @statechart.buildView = community.views.BuildView.create
      coordinator: @statechart

    buildView.appendTo @statechart.communityView.$()

  exitState: ->
    @statechart.buildView.remove()


  play: ->
    @gotoState 'Play'