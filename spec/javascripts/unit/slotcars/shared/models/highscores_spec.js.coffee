describe 'Highscores', ->

  beforeEach ->
    @runs = [
      { user_id: 1, rank: 1 }
      { user_id: 2, rank: 2 }
      { user_id: 3, rank: 3 }
      { user_id: 4, rank: 4 }
      { user_id: 5, rank: 5 }
      { user_id: 6, rank: 6 }
      { user_id: 7, rank: 7 }
    ]

  it 'should limit the displayedRuns by default to 5', ->
    highscores = Shared.Highscores.create
      runs: @runs

    (expect highscores.displayedRuns.length).toBe 5

  it 'should set the ID of the current user if available', ->
    currentUserBackup = Shared.User.current
    Shared.User.current = Ember.Object.create()
    sinon.stub(Shared.User.current, 'get').withArgs('id').returns 1

    highscores = Shared.Highscores.create
      runs: @runs

    (expect highscores.userId).toBe 1

    Shared.User.current = currentUserBackup

  it 'should be possible to set a custom limit for displayedRuns', ->
    highscores = Shared.Highscores.create
      runs: @runs
      numberOfEntriesToDisplay: 6

    (expect highscores.displayedRuns.length).toBe 6

  describe 'when current user is present', ->

    beforeEach ->
      @currentUserBackup = Shared.User.current
      Shared.User.current = mockEmberClass Shared.User, get: sinon.stub()

    afterEach ->
      Shared.User.current.restore()
      Shared.User.current = @currentUserBackup

    it 'should select the runs around the current users run', ->
      Shared.User.current.get.returns 4

      highscores = Shared.Highscores.create runs: @runs

      (expect highscores.displayedRuns[2].user_id).toBe 4

    it 'should select the correct runs when the current user is last', ->
      Shared.User.current.get.returns 7

      highscores = Shared.Highscores.create runs: @runs

      (expect highscores.displayedRuns[4].user_id).toBe 7

    it 'should select the correct runs when the current user is first', ->
      Shared.User.current.get.returns 1

      highscores = Shared.Highscores.create runs: @runs

      (expect highscores.displayedRuns[0].user_id).toBe 1

    it 'should select the correct runs when the current user is nearly the last', ->
      Shared.User.current.get.returns 6

      highscores = Shared.Highscores.create runs: @runs

      (expect highscores.displayedRuns[3].user_id).toBe 6

    it 'should select the correct runs when the current user is nearly the first', ->
      Shared.User.current.get.returns 2

      highscores = Shared.Highscores.create runs: @runs

      (expect highscores.displayedRuns[1].user_id).toBe 2

  describe 'when current user is not present', ->

    it 'should select the first 5 runs', ->
      highscores = Shared.Highscores.create runs: @runs

      (expect highscores.displayedRuns[0].rank).toBe 1
      (expect highscores.displayedRuns[4].rank).toBe 5


  describe '#getTimeForUserId', ->

    it 'should return the correct time for a given user id', ->
      highscores = Shared.Highscores.create
        runs: [
          { user_id: 1, time: 1 }
          { user_id: 2, time: 2 }
          { user_id: 3, time: 3 }
        ]

      (expect highscores.getTimeForUserId 2).toBe 2
