
#= require helpers/math/vector

describe 'helpers.math.Vector (unit)', ->

  Vector = helpers.math.Vector

  describe '#create', ->

    it 'should take two points', ->
      pointA =
        x: 1
        y: 0

      pointB =
        x: 0
        y: 1

      vector = Vector.create from: pointA, to: pointB

      (expect vector.x).toBe -1
      (expect vector.y).toBe 1

  describe '#length', ->

    it 'should return length of vector', ->
      randomValue = Math.random(1) * 10
      vector = Vector.create x: randomValue, y: 0

      (expect vector.length()).toBe randomValue

  describe '#dot', ->

    it 'should return the dot product of vectors', ->
      vector1 = Vector.create x: 0, y: 1
      vector2 = Vector.create x: 1, y: 0

      (expect vector1.dot vector2).toBe 0

  describe '#angleFrom', ->

    it 'should return the angle between vectors in degree', ->
      vector1 = Vector.create x: 1, y: 0
      vector2 = Vector.create x: 1, y: 1

      (expect Math.floor vector1.angleFrom vector2).toBe 45

    it 'should return correct angle for orthogonal vectors', ->
      vector1 = Vector.create x: 0, y: 1
      vector2 = Vector.create x: 1, y: 0

      (expect Math.floor vector1.angleFrom vector2).toBe 90


