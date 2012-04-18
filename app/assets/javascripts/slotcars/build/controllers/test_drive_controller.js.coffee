
#= require slotcars/shared/controllers/base_game_controller

BaseGameController = Slotcars.shared.controllers.BaseGameController

Build.TestDriveController = BaseGameController.extend

  stateManager: null
  
  onEditTrack: ->
    @stateManager.goToState 'Editing'