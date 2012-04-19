describe 'button', ->

  it 'should extend Ember.Object', ->
    (expect Shared.Button).toExtend Ember.Object

  describe 'reseting', ->

    beforeEach ->
      @button = Shared.Button.create()

    it 'should set disabled to true', ->
      @button.reset()

      (expect @button.disabled).toBe true

    it 'should set active to false', ->
      @button.reset()

      (expect @button.active).toBe false
