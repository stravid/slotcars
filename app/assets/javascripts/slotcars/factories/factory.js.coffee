
Factory = (namespace 'Slotcars.factories').Factory = Ember.Object.extend

  _registeredTypes: []

  # any type/class can be provided that provides #create to create instances
  registerType: (id, type) -> @_registeredTypes[id] = type

  getInstanceOf: (typeId, createParamters={}) ->
    if @_registeredTypes[typeId]?
      @_registeredTypes[typeId].create createParamters
    else
      throw "#{typeId} was not registered in factory."

# reopenClass is used here to inherit the class methods (static) and attributes
# also to subclasses. Inside the class methods 'this' points to the class itself.
Factory.reopenClass

  instance: null

  # all subclasses will have their own singleton @instance because
  # 'this' points to the class that 'getInstance' is called on.
  getInstance: -> if @instance? then @instance else @instance = @create()