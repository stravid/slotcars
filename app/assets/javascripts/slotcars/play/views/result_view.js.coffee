#= require helpers/namespace
#= require slotcars/play/templates/result_view_template

namespace 'slotcars.play.views'

slotcars.play.views.ResultView = Ember.View.extend

  elementId: 'lap-time-view'
  templateName: 'slotcars_play_templates_result_view_template'
  gameController: null
