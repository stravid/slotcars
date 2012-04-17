
#= require embient/ember-layout
#= require slotcars/play/templates/play_screen_view_template

(namespace 'slotcars.play.views').PlayScreenView = Ember.View.extend

  elementId: 'play-screen-view'
  templateName: 'slotcars_play_templates_play_screen_view_template'
  contentView: null
  clockView: null
  gameView: null
  carView: null
    