Play.ClockView = Ember.View.extend

  elementId: 'clock'
  templateName: 'slotcars_play_templates_clock_view_template'

  track: null
  car: null
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

  lapClass: "letter-0"

  lapChar: null
  totalLapClass: "letter-0"
  totalLapChar: null

  didInsertElement: ->
    @chars = [
      @$('#clock-minutes .first')
      @$('#clock-minutes .second')
      @$('#clock-seconds .first')
      @$('#clock-seconds .second')
      @$('#clock-milliseconds .first')
      @$('#clock-milliseconds .second')
    ]

    @lapChar = @$('#clock-lap .first')
    @totalLapChar = @$('#clock-lap .third')

    @updateLapAmount @track.get 'numberOfLaps'

  onUpdateRaceTime: ( ->
    @updateTime @gameController.get 'raceTime'
  ).observes 'gameController.raceTime'

  onUpdateLab: ( ->
    @updateLap @car.get 'currentLap'
  ).observes 'car.currentLap'

  updateTime: (time) ->
    date = new Date()
    date.setTime time

    minutes = Shared.fixedLengthNumber date.getMinutes()
    seconds = Shared.fixedLengthNumber date.getSeconds()
    milliseconds = Shared.fixedLengthNumber date.getMilliseconds(), 3

    @_setLetters [
      minutes.substr 0, 1
      minutes.substr 1, 1
      seconds.substr 0, 1
      seconds.substr 1, 1
      milliseconds.substr 0, 1
      milliseconds.substr 1, 1
    ]

  updateLap: (lap) ->
    return unless @lapChar?

    @lapChar.removeClass @lapClass
    @lapClass = "letter-#{lap.toString().substr(-1, 1)}"
    @lapChar.addClass @lapClass

  updateLapAmount: (amount) ->
    @totalLapChar.removeClass @totalLapClass
    @totalLapClass = "letter-#{amount.toString().substr(-1, 1)}"
    @totalLapChar.addClass @totalLapClass

  _setLetters: (letters) ->
    return unless @chars?

    for char, i in @chars
      char.removeClass @values[i]

      className = "letter-#{letters[i]}"
      @values[i] = className
      char.addClass className
