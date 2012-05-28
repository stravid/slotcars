Play.Countdownable = Ember.Mixin.create

  isCountdownVisible: false
  currentCountdownValue: null
  timers: []

  startCountdown: (countdownFinishedCallback) ->
    @resetCountdown()

    @timers.push Ember.run.later this, @setCountdownValue, 2, 1000
    @timers.push Ember.run.later this, @setCountdownValue, 1, 2000

    @timers.push Ember.run.later this, @finishCountdown, countdownFinishedCallback, 3000

    @timers.push Ember.run.later this, @hideCountdown, 3500

  resetCountdown: ->
    @cancelTimers()
    @setCountdownValue 3
    @showCountdown()

  cancelTimers: ->
    Ember.run.cancel timer for timer in @timers

    @timers = []

  setCountdownValue: (value) -> @set 'currentCountdownValue', value

  finishCountdown: (finishCallback) ->
    finishCallback() if finishCallback?
    @setCountdownValue 'Go!'

  showCountdown: -> @set 'isCountdownVisible', true

  hideCountdown: -> @set 'isCountdownVisible', false
