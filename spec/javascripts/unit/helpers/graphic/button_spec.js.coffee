describe 'button', ->

  Button = helpers.graphic.Button

  it 'should extend Ember.Object', ->
    (expect Button).toExtend Ember.Object

  describe 'reseting', ->

    beforeEach ->
      @button = Button.create()

    it 'should set disabled to true', ->
      @button.reset()

      (expect @button.disabled).toBe true

    it 'should set active to false', ->
      @button.reset()

      (expect @button.active).toBe false
