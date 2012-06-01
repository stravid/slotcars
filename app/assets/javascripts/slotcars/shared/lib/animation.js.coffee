Shared.Animation = Ember.Object.extend

  options: {} # useful properties: duration, delay
  fn: null
  callback: null

  run: ->
    @options.delay = @options.delay || 0

    Ember.run.later (=>
      @fn()
      Ember.run.later (=> @callback()), @options.duration
    ), @options.delay

    return this
