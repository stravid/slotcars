describe 'Play.ClockView (unit)', ->
  
  beforeEach ->
    @TrackMock = mockEmberClass Shared.Track
    @CarMock = mockEmberClass Shared.Car, track: @TrackMock

    @gameControllerMock = mockEmberClass Play.GameController,
      track: @TrackMock
      car: @CarMock

    @clockView = Play.ClockView.create
      gameController: @gameControllerMock
      car: @CarMock
      track: @TrackMock

  afterEach ->
    @TrackMock.restore()
    @CarMock.restore()
    @gameControllerMock.restore()
  
  it 'should extend Ember.View', ->
    (expect Play.ClockView).toExtend Ember.View
      
  it 'should call updateTime when raceTime changes in GameController', ->
    @clockView.updateTime = sinon.spy()
    @gameControllerMock.set 'raceTime', 28
    (expect @clockView.updateTime).toHaveBeenCalledWith 28
    
  it 'should call updateLap when currentLap changes in Car', ->
    @clockView.updateLap = sinon.spy()
    @CarMock.set 'currentLap', 2
    (expect @clockView.updateLap).toHaveBeenCalledWith 2
    
    
    
