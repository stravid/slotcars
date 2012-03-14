#= require helpers/namespace
#= require slotcars/play/templates/clock_template

namespace 'slotcars.play.views'

slotcars.play.views.ClockView = Ember.View.extend

  elementId: 'clock'
  templateName: 'slotcars_play_templates_clock_template'
  
  gameController: null
  chars: null
  values: [
    "letter-0"
    "letter-0"
    "letter-0"
    "letter-0"
  ]
    
  didInsertElement: ->
    @chars = [
      @$('#clock-seconds .first')
      @$('#clock-seconds .second')
      @$('#clock-milliseconds .first')
      @$('#clock-milliseconds .second')
    ]
    
  onUpdateRaceTime: ( ->
    @updateTime @gameController.get 'raceTime'
  ).observes 'gameController.raceTime'
  
  updateTime: (milliSeconds) ->
    seconds = milliSeconds / 1000
    secondsString = (~~seconds).toString()
    milliSecondString = (~~(milliSeconds / 10)).toString()
    
    firstLetter = if secondsString.length > 1 then secondsString.substr -2, 1 else '0'
    secondLetter = secondsString.substr -1, 1 
    thirdLetter = milliSecondString.substr -2, 1
    fourthLetter = milliSecondString.substr -1, 1
    
    @_setLetters [firstLetter, secondLetter, thirdLetter, fourthLetter]

  _setLetters: (letters) ->
    return unless @chars?
    
    @_removeClasses()
    
    for char, i in @chars
      className = "letter-#{letters[i]}"
      @values[i] = className
      char.addClass className
    

  _removeClasses: ->
    for char, i in @chars
      char.removeClass @values[i]