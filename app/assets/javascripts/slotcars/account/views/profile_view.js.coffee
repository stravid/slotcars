#= require vendor/iscroll

Account.ProfileView = Ember.View.extend

  delegate: null
  elementId: 'profile-widget-view'
  templateName: 'slotcars_account_templates_profile_view_template'

  user: null
  logoutFailed: false
  
  iScroller: null
  isInsertingScroller: false

  onLogoutButtonClicked: -> (@get 'delegate').signOutCurrentUser()
  
  didInsertElement: -> @initializeHighscoreScroller()
  
  initializeHighscoreScroller: ->
    targetElement = @$('#highscore-scroller')
    
    if targetElement.length > 0
      @set 'iScroller', new iScroll 'highscore-scroller', hideScrollbar: false
    else
      Ember.run.later (=> @initializeHighscoreScroller()), 50