
#= require slotcars/shared/controllers/base_game_controller

Build.TestDriveController = Shared.BaseGameController.extend

  stateManager: null
  
  onEditTrack: ->
    @stateManager.goToState 'Editing'