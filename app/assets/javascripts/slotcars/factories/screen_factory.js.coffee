
#= require slotcars/factories/factory

Shared.ScreenFactory = Shared.Factory.extend

  registerScreen: (id, screenType) -> @registerType id, screenType

  getInstanceOf: (typeId, createParamters={}) ->
    instance = @_super typeId, createParamters
    Shared.Appendable.apply instance
    Shared.Animatable.apply instance
