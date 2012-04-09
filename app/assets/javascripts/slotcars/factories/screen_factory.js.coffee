
#= require slotcars/factories/factory

ScreenFactory = (namespace 'slotcars.factories').ScreenFactory = Slotcars.factories.Factory.extend

  registerScreen: (id, screenType) -> @registerType id, screenType