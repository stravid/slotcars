describe 'abstract factory', ->

  Factory = Slotcars.factories.Factory

  describe 'registering types and getting instances', ->

    beforeEach ->
      @factory = Factory.create()
      @ExpectedType = Ember.Object.extend()
      @factory.registerType 'ExpectedType', @ExpectedType

    it 'should throw when trying to get an instance of an unregistered type', ->
      type = 'NotRegistered'

      getUnregisteredType = => @factory.getInstanceOf type

      (expect getUnregisteredType).toThrow "#{type} was not registered in factory."

    it 'should return instances for registered type', ->
      returnedInstance =  @factory.getInstanceOf 'ExpectedType'

      (expect returnedInstance).toBeInstanceOf @ExpectedType

    it 'should provide parameter hash when creating instance', ->
      instanceWithParams = @factory.getInstanceOf 'ExpectedType', x: 'provided', y: 'param'

      (expect instanceWithParams.get 'x').toBe 'provided'
      (expect instanceWithParams.get 'y').toBe 'param'

    it 'should be possible to register multiple types', ->
      @SecondType = Ember.Object.extend()
      @factory.registerType 'SecondType', @SecondType

      @ThirdType = Ember.Object.extend()
      @factory.registerType 'ThirdType', @ThirdType

      secondInstance = @factory.getInstanceOf 'SecondType'
      thirdInstance = @factory.getInstanceOf 'ThirdType'

      (expect secondInstance).toBeInstanceOf @SecondType
      (expect thirdInstance).toBeInstanceOf @ThirdType


  describe 'getting singleton instance of factory', ->

    it 'should provide a method to always retrieve the same instance', ->
      firstInstance = Factory.getInstance()
      secondInstance = Factory.getInstance()

      (expect firstInstance).toBeInstanceOf Factory
      (expect secondInstance).toBe firstInstance

    it 'should correctly inherit static method to subclasses', ->
      FirstFactory = Factory.extend()
      SecondFactory = Factory.extend()

      instanceOfFirstFactory = FirstFactory.getInstance()
      instanceOfSecondFactory = SecondFactory.getInstance()

      (expect instanceOfFirstFactory).not.toBe instanceOfSecondFactory