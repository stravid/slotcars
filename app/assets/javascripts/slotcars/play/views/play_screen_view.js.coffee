
#= require helpers/namespace
#= require slotcars/play/templates/play_screen_view_template

namespace 'slotcars.play.views'

slotcars.play.views.PlayScreenView = Ember.View.extend

  elementId: 'play-screen-view'
  templateName: 'slotcars_play_templates_play_screen_view_template'
  contentView: null
    