
Factory = (namespace 'Slotcars.factories').Factory = Ember.Object.extend

  _registeredTypes: []

  registerType: (id, type) -> @_registeredTypes[id] = type

  getInstanceOf: (typeId, createParamters={}) ->
    if @_registeredTypes[typeId]?
      @_registeredTypes[typeId].create createParamters
    else
      throw "#{typeId} was not registered in factory."