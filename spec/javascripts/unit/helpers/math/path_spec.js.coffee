
#= require helpers/math/path

describe 'helpers.math.Path', ->

  Path = helpers.math.Path

  describe '#create', ->

    it 'should create a linked list form given points', ->
      points = [
        { x: 0, y: 0, angle: 0}
        { x: 1, y: 0, angle: 0}
        { x: 2, y: 0, angle: 0}
      ]

      path = Path.create points: points

      (expect path.head.x).toEqual points[0].x
      (expect path.tail.y).toEqual points[2].y
      (expect path.head.next.x).toEqual points[1].x
      (expect path.tail.previous.y).toEqual points[1].y

    it 'should be possible to create path without parameters', ->
      (expect => Path.create()).not.toThrow()


  describe '#push', ->

    it 'should recalculate angle for new point and neighbours when told so', ->
      points = [
        { x: 0, y: 0, angle: 45}
        { x: 1, y: 0, angle: 90}
        { x: 1, y: 1, angle: 45}
      ]

      path = Path.create points: points
      path.push { x: 0, y: 1, angle: null}, true

      (expect path.asPointArray()).toEqual [
        { x: 0, y: 0, angle: 90}
        { x: 1, y: 0, angle: 90}
        { x: 1, y: 1, angle: 90}
        { x: 0, y: 1, angle: 90}
      ]

  describe '#asPointArray', ->

    it 'should return all elements as array', ->
      points = [
        { x: 0, y: 0, angle: 0}
        { x: 1, y: 0, angle: 0}
        { x: 2, y: 0, angle: 0}
      ]

      path = Path.create points: points

      (expect path.asPointArray()).toEqual points

  describe '#clean', ->

    it 'should remove points with angle < minAngle if resulting vector is appropriate', ->
      points = [
        { x: 0, y: 0, angle: 0}
        { x: 1, y: 0, angle: 0}
        { x: 2, y: 0, angle: 0}
        { x: 3, y: 0, angle: 0}
      ]

      path = Path.create points: points
      path.clean minAngle: 5, minLength: 2, maxLength: 3

      (expect path.asPointArray()).toEqual [
        { x: 1, y: 0, angle: 180}
        { x: 3, y: 0, angle: 0}
      ]

    it 'should remove points if vectors are too short', ->
      points = [
        { x: 1, y: 0, angle: 10}
        { x: 2, y: 0, angle: 20}
        { x: 3, y: 0, angle: 15}
      ]

      path = Path.create points: points
      path.clean minAngle: 5, minLength: 2, maxLength: 5

      (expect path.asPointArray()).toEqual [
        { x: 1, y: 0, angle: 180}
        { x: 3, y: 0, angle: 15}
      ]

    it 'should add points if a vector is too long', ->
      points = [
        { x: 0, y: 0, angle: 10}
        { x: 10, y: 0, angle: 10}
      ]

      path = Path.create points: points
      path.clean minAngle: 5, minLength: 2, maxLength: 5

      (expect path.asPointArray()).toEqual [
        { x: 5, y: 0, angle: 0}
        { x: 0, y: 0, angle: 10}
        { x: 5, y: 0, angle: 0}
        { x: 10, y: 0, angle: 10}
      ]


  describe 'smooth', ->

    it 'should remove and interpolate points with angle > threshold', ->
      points = [
        { x: 0, y: 1, angle: 45}
        { x: 0, y: 0, angle: 90}
        { x: 1, y: 0, angle: 45}
      ]

      path = Path.create points: points
      path.smooth 70
      results = path.asPointArray()

      for result in results
        result.angle =  (Math.floor result.angle)

      (expect results).toEqual [
        { x: 0, y: 1, angle: 45}
        { x: 0, y: 0.5, angle: 45}
        { x: 0.5, y: 0, angle: 45}
        { x: 1, y: 0, angle: 45}
      ]

    it 'should smooth recursively until all points have angle < threshold', ->
      points = [
        { x: 0, y: 1, angle: 0}
        { x: 0, y: 0, angle: 90}
        { x: 1, y: 0, angle: 0}
      ]

      path = Path.create points: points
      path.smooth 44
      results = path.asPointArray()

      for result in results
        result.angle =  (Math.round result.angle)

      (expect results).toEqual [
        { x: 0, y: 1, angle: 0}
        { x: 0, y: 0.75, angle: 27}
        { x: 0.25, y: 0.25, angle: 18}
        { x: 0.375, y: 0.125, angle: 27}
        { x: 0.75, y: 0, angle: 18}
        { x: 1, y: 0, angle: 0}
      ]