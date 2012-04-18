describe 'helpers.math.Path', ->

  Path = helpers.math.Path

  describe '#create', ->

    it 'should create a linked list form given points', ->
      points = [
        { x: 0, y: 0, angle: 0 }
        { x: 1, y: 0, angle: 0 }
        { x: 2, y: 0, angle: 0 }
      ]

      path = Path.create points: points

      (expect path.head.x).toEqual points[0].x
      (expect path.tail.y).toEqual points[2].y
      (expect path.head.next.x).toEqual points[1].x
      (expect path.tail.previous.y).toEqual points[1].y

    it 'should be possible to create path without parameters', ->
      (expect => Path.create()).not.toThrow()

    it 'should convert point attributes to float', ->
      points = [
        { x: '0.00', y: '1.37', angle: '1.00' }
      ]

      path = Path.create points: points

      (expect path.head.x).toEqual 0
      (expect path.head.y).toEqual 1.37
      (expect path.head.angle).toEqual 1

  describe '#push', ->

    it 'should recalculate angle for new point and neighbours when told so', ->
      points = [
        { x: 0, y: 0, angle: 45 }
        { x: 1, y: 0, angle: 90 }
        { x: 1, y: 1, angle: 45 }
      ]

      path = Path.create points: points
      path.push { x: 0, y: 1, angle: null }, true

      (expect path.asPointArray()).toEqual [
        { x: 0, y: 0, angle: 90 }
        { x: 1, y: 0, angle: 90 }
        { x: 1, y: 1, angle: 90 }
        { x: 0, y: 1, angle: 90 }
      ]

  describe '#asPointArray', ->

    it 'should return all elements as array', ->
      points = [
        { x: 0, y: 0, angle: 0 }
        { x: 1, y: 0, angle: 0 }
        { x: 2, y: 0, angle: 0 }
      ]

      path = Path.create points: points

      (expect path.asPointArray()).toEqual points

  describe '#asFixedLengthPointArray', ->

    it 'should return all elements with a fixed length as array', ->
      inputPoints = [
        { x: 1.555, y: 4.22, angle: 3.1 }
      ]

      outputPoints = [
        { x: '1.55', y: '4.22', angle: '3.10' }
      ]

      path = Path.create points: inputPoints

      (expect path.asFixedLengthPointArray()).toEqual outputPoints

  describe '#clean', ->

    it 'should remove points with angle < minAngle if resulting vector is appropriate', ->
      points = [
        { x: 0, y: 0, angle: 0 }
        { x: 1, y: 0, angle: 0 }
        { x: 2, y: 0, angle: 0 }
        { x: 3, y: 0, angle: 0 }
      ]

      path = Path.create points: points
      path.clean minAngle: 5, minLength: 2, maxLength: 3

      (expect path.asPointArray()).toEqual [
        { x: 1, y: 0, angle: 180 }
        { x: 2, y: 0, angle: 0 }
        { x: 3, y: 0, angle: 0 }
      ]

    it 'should remove points if vectors are too short', ->
      points = [
        { x: 1, y: 0, angle: 10 }
        { x: 2, y: 0, angle: 20 }
        { x: 3, y: 0, angle: 15 }
        { x: 4, y: 0, angle: 20 }
      ]

      path = Path.create points: points
      path.clean minAngle: 5, minLength: 2, maxLength: 5

      (expect path.asPointArray()).toEqual [
        { x: 1, y: 0, angle: 180 }
        { x: 3, y: 0, angle: 15 }
        { x: 4, y: 0, angle: 20 }
      ]

    it 'should add points if a vector is too long', ->
      points = [
        { x: 0, y: 0, angle: 10 }
        { x: 10, y: 0, angle: 10 }
        { x: 7, y: 0, angle: 10 }
        { x: 4, y: 0, angle: 10 }
      ]

      path = Path.create points: points
      path.clean minAngle: 5, minLength: 2, maxLength: 5

      (expect path.asPointArray()).toEqual [
        { x: 0, y: 0, angle: 10 }
        { x: 5, y: 0, angle: 0 }
        { x: 10, y: 0, angle: 10 }
        { x: 7, y: 0, angle: 10 }
        { x: 4, y: 0, angle: 10 }
      ]

  describe '#getTotalLength', ->

    beforeEach ->
      @path = Path.create()


    it 'should have total length of zero without points', ->
      (expect @path.getTotalLength()).toBe 0

    it 'should calculate total length of path in pixels when created', ->
      points = [
        { x: 0, y: 0, angle: 0 }
        { x: 1, y: 0, angle: 0 }
        { x: 1, y: 1, angle: 0 }
        { x: 0, y: 1, angle: 0 }
      ]

      path = Path.create points: points

      (expect path.getTotalLength()).toBe 4

    it 'should update total length when points are inserted', ->
      points = [
        { x: 0, y: 0, angle: 0 }
        { x: 1, y: 0, angle: 0 }
      ]

      path = Path.create points: points
      (expect path.getTotalLength()).toBe 2

      path.insertBefore path.tail, {x: 2, y:0, angle:0 }

      (expect path.getTotalLength()).toBe 4

    it 'should update total length when points are removed', ->
      points = [
        { x: 0, y: 0, angle: 0 }
        { x: 0.5, y: 0, angle: 0 }
        { x: 1, y: 0, angle: 0 }
        { x: 1, y: 1, angle: 0 }
        { x: 0, y: 1, angle: 0 }
      ]

      path = Path.create points: points
      (expect path.getTotalLength()).toBe 4

      path.remove path.head.next

      (expect path.getTotalLength()).toBe 4


  describe '#getPointAtLength', ->

    beforeEach ->
      @points = [
        { x: 0, y: 0, angle: 1 }
        { x: 1, y: 0, angle: 2 }
        { x: 1, y: 1, angle: 3 }
        { x: 0, y: 1, angle: 4 }
      ]

      @path = Path.create points: @points

    it 'should return zero point if no points in path', ->
      path = Path.create()
      (expect path.getPointAtLength 1).toEqual x: 0, y: 0, angle: 0

    it 'should return defined points at length', ->
      (expect @path.getPointAtLength 2).toEqual x:1 , y: 1, angle: 3

    it 'should calculate intermediate points for any length', ->
      (expect @path.getPointAtLength 1.5).toEqual x: 1, y: 0.5, angle: 3

    it 'should return correct point when searched length > total length', ->
      (expect @path.getPointAtLength 5).toEqual x: 1, y: 0, angle: 2
