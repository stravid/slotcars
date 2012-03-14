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
    "letter-0"
    "letter-0"
  ]
    
  didInsertElement: ->
    @chars = [
      @$('#clock-minutes .first')
      @$('#clock-minutes .second')
      @$('#clock-seconds .first')
      @$('#clock-seconds .second')
      @$('#clock-milliseconds .first')
      @$('#clock-milliseconds .second')
    ]
    
  onUpdateRaceTime: ( ->
    @updateTime @gameController.get 'raceTime'
  ).observes 'gameController.raceTime'
  
  updateTime: (time) ->
    date = new Date()
    date.setTime time
    
    minutes = @_twoDigets date.getMinutes()
    seconds = @_twoDigets date.getSeconds()
    milliseconds = @_twoDigets date.getMilliseconds()
    
    @_setLetters [
      minutes.substr 0, 1
      minutes.substr 1, 1
      seconds.substr 0, 1 
      seconds.substr 1, 1
      milliseconds.substr 0, 1
      milliseconds.substr 1, 1 
    ]

  _setLetters: (letters) ->
    return unless @chars?

    for char, i in @chars
      char.removeClass @values[i]
      
      className = "letter-#{letters[i]}"
      @values[i] = className
      char.addClass className
      
  _twoDigets: (value) ->
    value = value.toString()
    if value.length >= 2 then value.substr(0, 2) else "0#{value}"
