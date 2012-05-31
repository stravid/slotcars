Play.Countdownable = Ember.Mixin.create

  isCountdownVisible: false
  currentCountdownClass: null
  timers: []

  startCountdown: (countdownFinishedCallback) ->
    @resetCountdown()

    @timers.push Ember.run.later this, @setCountdownValue, 'second', 1000
    @timers.push Ember.run.later this, @setCountdownValue, 'third', 2000

    @timers.push Ember.run.later this, @finishCountdown, countdownFinishedCallback, 3000

    @timers.push Ember.run.later this, @hideCountdown, 3500

  resetCountdown: ->
    @cancelTimers()
    @setCountdownValue 'first'
    @showCountdown()

  cancelTimers: ->
    Ember.run.cancel timer for timer in @timers
    @timers = []

  setCountdownValue: (value) -> @set 'currentCountdownClass', value

  finishCountdown: (finishCallback) ->
    finishCallback() if finishCallback?
    @setCountdownValue 'fourth'

  showCountdown: -> @set 'isCountdownVisible', true

  hideCountdown: -> @set 'isCountdownVisible', false
