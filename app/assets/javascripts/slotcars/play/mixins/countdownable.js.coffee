Play.Countdownable = Ember.Mixin.create

  isCountdownVisible: false
  currentCountdownValue: null

  startCountdown: (countdownFinishedCallback) ->
    @resetCountdown()

    Ember.run.later this, @setCountdownValue, 2, 1000
    Ember.run.later this, @setCountdownValue, 1, 2000

    Ember.run.later this, @finishCountdown, countdownFinishedCallback, 3000

    Ember.run.later this, @hideCountdown, 3500

  resetCountdown: ->
    @setCountdownValue 3
    @showCountdown()

  setCountdownValue: (value) -> @set 'currentCountdownValue', value

  finishCountdown: (finishCallback) ->
    finishCallback() if finishCallback?
    @setCountdownValue 'Go!'

  showCountdown: -> @set 'isCountdownVisible', true

  hideCountdown: -> @set 'isCountdownVisible', false