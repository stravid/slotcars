
#= require slotcars/factories/factory

Factory = Slotcars.factories.Factory

(namespace 'Slotcars.factories').WidgetFactory = Factory.extend

  registerWidget: (id, widgetType) -> @registerType id, widgetType