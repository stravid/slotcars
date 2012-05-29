Play.PlayScreenView = Ember.View.extend

  elementId: 'play-screen-view'
  templateName: 'slotcars_play_templates_play_screen_view_template'
  contentView: null

  didInsertElement: -> # Don´t use - it is overridden by Shared.Animatable
