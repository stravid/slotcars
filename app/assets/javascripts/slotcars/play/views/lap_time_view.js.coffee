#= require helpers/namespace
#= require slotcars/play/templates/lap_time_view_template

namespace 'slotcars.play.views'

slotcars.play.views.LapTimeView = Ember.View.extend

  elementId: 'lap-time-view'
  templateName: 'slotcars_play_templates_lap_time_view_template'
  gameController: null
  
  onRaceStatusChange: (->
    
  ).observes 'gameController.isRaceFinished'
