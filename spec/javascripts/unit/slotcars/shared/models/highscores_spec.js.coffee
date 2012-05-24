describe 'Highscores', ->

  it 'should add ranks to the runs', ->
    highscores = Shared.Highscores.create
      runs: [{},{}]

    (expect highscores.runs[0].rank).toBe 1
    (expect highscores.runs[1].rank).toBe 2

  it 'should limit the displayedRuns by default to 5', ->
    highscores = Shared.Highscores.create
      runs: [{}, {}, {}, {}, {}, {}]

    (expect highscores.displayedRuns.length).toBe 5

  it 'should be possible to set a custom limit for displayedRuns', ->
    highscores = Shared.Highscores.create
      runs: [{}, {}, {}, {}, {}, {}, {}, {}]
      numberOfEntriesToDisplay: 7

    (expect highscores.displayedRuns.length).toBe 7

  describe 'when current user is present', ->

    beforeEach ->
      @runs = [
        { user_id: 1 }
        { user_id: 2 }
        { user_id: 3 }
        { user_id: 4 }
        { user_id: 5 }
        { user_id: 6 }
        { user_id: 7 }
      ]

    it 'should select the runs around the current users run', ->
      highscores = Shared.Highscores.create
        runs: @runs
        userId: 4

      (expect highscores.displayedRuns[2].user_id).toBe 4

    it 'should select the correct runs when the current user is last', ->
      highscores = Shared.Highscores.create
        runs: @runs
        userId: 7

      (expect highscores.displayedRuns[4].user_id).toBe 7

    it 'should select the correct runs when the current user is first', ->
      highscores = Shared.Highscores.create
        runs: @runs
        userId: 1

      (expect highscores.displayedRuns[0].user_id).toBe 1

    it 'should select the correct runs when the current user is nearly the last', ->
      highscores = Shared.Highscores.create
        runs: @runs
        userId: 6

      (expect highscores.displayedRuns[3].user_id).toBe 6

    it 'should select the correct runs when the current user is nearly the first', ->
      highscores = Shared.Highscores.create
        runs: @runs
        userId: 2

      (expect highscores.displayedRuns[1].user_id).toBe 2

  describe '#getTimeForUserId', ->

    it 'should return the correct time for a given user id', ->
      highscores = Shared.Highscores.create
        runs: [
          { user_id: 1, time: 1 }
          { user_id: 2, time: 2 }
          { user_id: 3, time: 3 }
        ]

      (expect highscores.getTimeForUserId 2).toBe 2
