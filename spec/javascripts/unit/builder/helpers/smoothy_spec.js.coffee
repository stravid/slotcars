
#= require builder/helpers/smoothy

describe 'builder.helpers.Smoothy', ->

  Smoothy = builder.helpers.Smoothy

  describe 'smooth', ->

    it 'should take an array of points and a threshold and return an array of points', ->
      points = [
        { x: 0, y: 0, angle: 0}
        { x: 1, y: 0, angle: 0}
      ]

      (expect Ember.typeOf Smoothy.smooth points, 10).toBe 'array'

    it 'should remove interpolate points with angle > threshold', ->
      points = [
        { x: 0, y: 1, angle: 0}
        { x: 0, y: 0, angle: 90}
        { x: 1, y: 0, angle: 0}
      ]

      results = Smoothy.smooth points, 70

      for result in results
        result.angle =  (Math.floor result.angle)

      (expect results).toEqual [
        { x: 0, y: 1, angle: 0}
        { x: 0, y: 0.5, angle: 45}
        { x: 0.5, y: 0, angle: 45}
        { x: 1, y: 0, angle: 0}
      ]

    it 'should smooth recursively until all points have angle < threshold', ->
      points = [
        { x: 0, y: 1, angle: 0}
        { x: 0, y: 0, angle: 90}
        { x: 1, y: 0, angle: 0}
      ]

      results = Smoothy.smooth points, 44

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

    it 'should smooth loops of points (go over start/end points)', ->
      points = [
        { x: 0, y: 1, angle: 90}
        { x: 0, y: 0, angle: 90}
        { x: 1, y: 0, angle: 90}
        { x: 1, y: 1, angle: 90}
      ]

      results = Smoothy.smooth points, 45

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