
#= require helpers/namespace
#= require community/templates/play_template
#= require game/game_application

namespace 'community.views'

community.views.PlayView = Ember.View.extend

  elementId: 'play-view'
  templateName: 'community_templates_play_template'

  gameApplication: game.GameApplication