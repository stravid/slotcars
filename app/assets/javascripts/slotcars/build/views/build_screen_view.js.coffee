Build.BuildScreenView = Ember.View.extend

  elementId: 'build-screen-view'
  templateName: 'slotcars_build_templates_build_screen_view_template'
  contentView: null

  stateManager: null

  init: ->
    @_super()
    @set 'drawButton', Shared.Button.create()
    @set 'testdriveButton', Shared.Button.create()
    @set 'editButton', Shared.Button.create()
    @set 'publishButton', Shared.Button.create()

  onDrawButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedDrawButton'

  onTestdriveButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedTestdriveButton'

  onPublishButtonClicked: (event) ->
    event.preventDefault() if event?
    @stateManager.send 'clickedPublishButton'

  onCurrentStateChanged: (->
    @_resetButtons()

    currentState = @stateManager.currentState
    reachableStates = currentState.reachableStates
    reachableStates ?= []

    for state in reachableStates
      switch state
        when 'Drawing'    then @drawButton.set 'disabled', false
        when 'Editing'    then @editButton.set 'disabled', false
        when 'Testing'    then @testdriveButton.set 'disabled', false
        when 'Publishing' then @publishButton.set 'disabled', false

    switch currentState.name
      when 'Drawing'    then @drawButton.set 'active', true
      when 'Editing'    then @editButton.set 'active', true
      when 'Testing'    then @testdriveButton.set 'active', true
      when 'Publishing' then @publishButton.set 'active', true

  ).observes 'stateManager.currentState'

  _resetButtons: ->
    @drawButton.reset()
    @editButton.reset()
    @testdriveButton.reset()
    @publishButton.reset()
