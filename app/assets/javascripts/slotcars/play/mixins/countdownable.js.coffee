Play.Countdownable = Ember.Mixin.create

  isCountdownVisible: false
  isCountdownFinished: false
  currentCountdownClass: null
  timers: []

  startCountdown: (countdownFinishedCallback) ->
    @resetCountdown()

    @timers.push Ember.run.later this, @setCountdownValue, 'second', 1000
    @timers.push Ember.run.later this, @setCountdownValue, 'third', 2000

    @timers.push Ember.run.later this, @finishCountdown, countdownFinishedCallback, 3000

    @timers.push Ember.run.later this, @hideCountdown, 4000

  resetCountdown: ->
    @cancelTimers()
    @setCountdownValue 'first'
    @set 'isCountdownFinished', false
    @showCountdown()

  cancelTimers: ->
    Ember.run.cancel timer for timer in @timers
    @timers = []

  setCountdownValue: (value) -> @set 'currentCountdownClass', value

  finishCountdown: (finishCallback) ->
    finishCallback() if finishCallback?
    @setCountdownValue 'fourth'
    @set 'isCountdownFinished', true

  showCountdown: -> @set 'isCountdownVisible', true

  hideCountdown: -> @set 'isCountdownVisible', false
