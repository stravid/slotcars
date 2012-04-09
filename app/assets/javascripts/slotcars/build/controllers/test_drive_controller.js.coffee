
#= require slotcars/shared/controllers/base_game_controller

BaseGameController = Slotcars.shared.controllers.BaseGameController

(namespace 'Slotcars.build.controllers').TestDriveController = BaseGameController.extend

  stateManager: null
  
  onEditTrack: ->
    @stateManager.goToState 'Editing'