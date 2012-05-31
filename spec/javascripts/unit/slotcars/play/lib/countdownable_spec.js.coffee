
describe 'Play.Countdownable', ->

  beforeEach -> @countdownable = Ember.Object.extend(Play.Countdownable).create()

  describe 'starting a countdown', ->

    beforeEach ->
      sinon.stub @countdownable, 'resetCountdown'
      sinon.stub Ember.run, 'later'
      sinon.stub @countdownable, 'setCountdownValue'

    afterEach -> Ember.run.later.restore()

    it 'should reset countdown to start value', ->
      @countdownable.startCountdown()

      (expect @countdownable.resetCountdown).toHaveBeenCalled()

    it 'should set the countdown class to second after 1000 milliseconds', ->
      @countdownable.startCountdown()

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.setCountdownValue,
                                                    'second',
                                                    1000

    it 'should set the countdown class to third after 2000 milliseconds', ->
      @countdownable.startCountdown()

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.setCountdownValue,
                                                    'third',
                                                    2000

    it 'should finish the countdown after 3000 milliseconds', ->
      finishCallback = sinon.spy()

      @countdownable.startCountdown finishCallback

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.finishCountdown,
                                                    finishCallback,
                                                    3000


    it 'should hide the countdown after 4000 milliseconds', ->
      @countdownable.startCountdown()

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.hideCountdown,
                                                    4000

    it 'should store all created timers', ->
      sinon.spy @countdownable.timers, 'push'

      @countdownable.startCountdown()

      (expect @countdownable.timers.push.callCount).toBe Ember.run.later.callCount

  describe 'resetting the countdown', ->

    beforeEach ->
      sinon.stub @countdownable, 'showCountdown'
      sinon.stub @countdownable, 'cancelTimers'

    it 'should set the countdown class to first', ->
      @countdownable.resetCountdown()

      (expect @countdownable.get 'currentCountdownClass').toBe 'first'

    it 'should show the countdown', ->
      @countdownable.resetCountdown()

      (expect @countdownable.showCountdown).toHaveBeenCalled()

    it 'should cancel the timers', ->
      @countdownable.resetCountdown()

      (expect @countdownable.cancelTimers).toHaveBeenCalled()


  describe 'setting the countdown value', ->

    it 'should set the current countdown value', ->
      @countdownable.set 'currentCountdownClass', 0
      testValue = 3

      @countdownable.setCountdownValue testValue

      (expect @countdownable.get 'currentCountdownClass').toBe testValue


  describe 'finishing the countdown', ->

    beforeEach -> sinon.stub @countdownable, 'setCountdownValue'

    it 'should call the finish callback', ->
      finishCallback = sinon.spy()

      @countdownable.finishCountdown finishCallback

      (expect finishCallback).toHaveBeenCalled()

    it 'should set the current countdown value to go', ->
      @countdownable.finishCountdown()

      (expect @countdownable.setCountdownValue).toHaveBeenCalledWith 'fourth'


  describe 'showing the countdown', ->

    it 'should set the countdown is visible flag to true', ->
      @countdownable.set 'isCountdownVisible', false

      @countdownable.showCountdown()

      (expect @countdownable.get 'isCountdownVisible').toBe true


  describe 'hiding the countdown', ->

    it 'should set the countdown is visible flag to false', ->
      @countdownable.set 'isCountdownVisible', true

      @countdownable.hideCountdown()

      (expect @countdownable.get 'isCountdownVisible').toBe false

  describe 'canceling the timers', ->

    beforeEach ->
      @fakeTimer = sinon.useFakeTimers()

    afterEach ->
      @fakeTimer.restore()

    it 'should cancel all stored timers', ->
      spy = sinon.spy()

      @countdownable.timers.push Ember.run.later this, spy, 1000
      @countdownable.timers.push Ember.run.later this, spy, 2000

      @countdownable.cancelTimers()

      @fakeTimer.tick 3000

      (expect spy).not.toHaveBeenCalled()

    it 'should reset the timers array', ->
      @countdownable.timers = ['a', 'b', 'c']

      @countdownable.cancelTimers()

      (expect @countdownable.timers.length).toBe 0

