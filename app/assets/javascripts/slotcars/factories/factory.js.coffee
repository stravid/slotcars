
#= require slotcars/shared/lib/singleton

Shared.Factory = Shared.Singleton.extend

  _registeredTypes: []

  # any type/class can be provided that provides #create to create instances
  registerType: (id, type) -> @_registeredTypes[id] = type

  getInstanceOf: (typeId, createParamters={}) ->
    if @_registeredTypes[typeId]?
      @_registeredTypes[typeId].create createParamters
    else
      throw "#{typeId} was not registered in factory."
