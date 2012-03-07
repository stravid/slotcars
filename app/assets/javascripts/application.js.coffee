#= require jquery
#= require jquery_ujs
#= require embient/ember
#= require slotcars/factories/screen_factory
#= require slotcars/slotcars_application

slotcars.SlotcarsApplication.create
  screenFactory: slotcars.factories.ScreenFactory.create()

