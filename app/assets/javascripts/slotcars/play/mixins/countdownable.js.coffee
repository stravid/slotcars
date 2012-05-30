Play.Countdownable = Ember.Mixin.create

  isCountdownVisible: false
  currentCountdownClass: null

  startCountdown: (countdownFinishedCallback) ->
    @resetCountdown()

    Ember.run.later this, @setCountdownValue, 'second', 1000
    Ember.run.later this, @setCountdownValue, 'third', 2000

    Ember.run.later this, @finishCountdown, countdownFinishedCallback, 3000

    Ember.run.later this, @hideCountdown, 4000

  resetCountdown: ->
    @setCountdownValue 'first'
    @showCountdown()

  setCountdownValue: (value) -> @set 'currentCountdownClass', value

  finishCountdown: (finishCallback) ->
    finishCallback() if finishCallback?
    @setCountdownValue 'fourth'

  showCountdown: -> @set 'isCountdownVisible', true

  hideCountdown: -> @set 'isCountdownVisible', false