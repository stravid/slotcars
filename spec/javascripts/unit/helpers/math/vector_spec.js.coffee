describe 'Shared.Vector (unit)', ->

  Vector = Shared.Vector

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

      (expect vector1.angleFrom vector2).toBeApproximatelyEqual 45

    it 'should return correct angle for orthogonal vectors', ->
      vector1 = Vector.create x: 0, y: 1
      vector2 = Vector.create x: 1, y: 0

      (expect vector1.angleFrom vector2).toBeApproximatelyEqual 90

    it 'should return angle zero for values that are NaN', ->
      vector1 = Vector.create x: 0, y: 1
      vector2 = Vector.create x: 0, y: 1

      (expect vector1.angleFrom vector2).toBeApproximatelyEqual 0

  describe '#clockwiseAngle', ->

    it 'should return correct angles for first quadrant', ->
      vector = Vector.create x: 1, y: -1

      (expect vector.clockwiseAngle()).toBeApproximatelyEqual 45

    it 'should return correct angles for second quadrant', ->
      vector = Vector.create x: 1, y: 1

      (expect vector.clockwiseAngle()).toBeApproximatelyEqual 135

    it 'should return correct angles for third quadrant', ->
      vector = Vector.create x: -1, y: 1

      (expect vector.clockwiseAngle()).toBeApproximatelyEqual 225

    it 'should return correct angles for fourth quadrant', ->
      vector = Vector.create x: -1, y: -1

      (expect vector.clockwiseAngle()).toBeApproximatelyEqual 315

  describe '#center', ->

    it 'should return the center point of the vector', ->
      vector = Vector.create x: 4, y: 4

      (expect vector.center()).toEqual Vector.create x: 2, y: 2

  describe '#normalize', ->

    it 'should return the normalized vector', ->
      vector = Vector.create x: 10, y: 12

      vector = vector.normalize()

      (expect vector.length()).toBe 1

  describe '#scale', ->

    it 'should return a scaled vector', ->
      vector = Vector.create x: 1, y: 0
      
      vector = vector.scale 5
      
      (expect vector.length()).toBe 5
    
