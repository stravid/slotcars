Play.HighscoresView = Ember.View.extend

  elementId: 'highscore-view'
  templateName: 'slotcars_play_templates_highscores_view_template'
  highscores: null
  
  onHighscoresChanged: (->
    @highlightCurrentUserHighscore() if Shared.User.current?
  ).observes 'highscores'
  
  highlightCurrentUserHighscore: ->
    currentUserId = Shared.User.current.get('id')
    
    Ember.run.later (=> 
      @$("tr[data-user-id=#{currentUserId}]").addClass "highlight"
    ), 100