Play.NewRunOnCurrentTrackNotificationView = Ember.View.extend

  templateName: 'slotcars_play_templates_new_run_on_current_track_notification_view_template'
  classNames: ['notification']

  delegate: null
  username: null
  time: null

  didInsertElement: ->
    Ember.run.later (=> @_fadeIn()), 10
    Ember.run.later (=> @_fadeOut()), 3000
    Ember.run.later (=> @_remove()), 4500
    
  _fadeIn: ->
    @$().css
      '-webkit-transition': 'opacity 0.2s ease-in'
      'opacity': 1

  _fadeOut: ->
    @$().css
      '-webkit-transition-timing-function': 'ease-in, linear, linear, linear'
      '-webkit-transition-property': 'opacity, height, padding, margin'
      '-webkit-transition-duration': '1.5s, 0.2s, 0.2s, 0.2s'
      '-webkit-transition-delay': '0s, 1.2s, 1.2s, 1.2s'
      'opacity': 0
      'height': 0
      'padding-top': 0
      'padding-bottom': 0
      'margin-top': 0

  _remove: ->
    (@get 'delegate').removeOldestNotification()
