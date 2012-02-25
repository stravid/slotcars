
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