
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

    it 'should set the countdown value to 2 after 1000 milliseconds', ->
      @countdownable.startCountdown()

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.setCountdownValue,
                                                    2,
                                                    1000

    it 'should set the countdown value to 1 after 2000 milliseconds', ->
      @countdownable.startCountdown()

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.setCountdownValue,
                                                    1,
                                                    2000

    it 'should finish the countdown after 3000 milliseconds', ->
      finishCallback = sinon.spy()

      @countdownable.startCountdown finishCallback

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.finishCountdown,
                                                    finishCallback,
                                                    3000


    it 'should hide the countdown after 3500 milliseconds', ->
      @countdownable.startCountdown()

      (expect Ember.run.later).toHaveBeenCalledWith @countdownable,
                                                    @countdownable.hideCountdown,
                                                    3500


  describe 'resetting the countdown', ->

    beforeEach -> sinon.stub @countdownable, 'showCountdown'

    it 'should set the countdown value to 3', ->
      @countdownable.resetCountdown()

      (expect @countdownable.get 'currentCountdownValue').toBe 3

    it 'should show the countdown', ->
      @countdownable.resetCountdown()

      (expect @countdownable.showCountdown).toHaveBeenCalled()


  describe 'setting the countdown value', ->

    it 'should set the current countdown value', ->
      @countdownable.set 'currentCountdownValue', 0
      testValue = 3

      @countdownable.setCountdownValue testValue

      (expect @countdownable.get 'currentCountdownValue').toBe testValue


  describe 'finishing the countdown', ->

    beforeEach -> sinon.stub @countdownable, 'setCountdownValue'

    it 'should call the finish callback', ->
      finishCallback = sinon.spy()

      @countdownable.finishCountdown finishCallback

      (expect finishCallback).toHaveBeenCalled()

    it 'should set the current countdown value to go', ->
      @countdownable.finishCountdown()

      (expect @countdownable.setCountdownValue).toHaveBeenCalledWith 'Go!'


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