Build.Publisher = Ember.Object.extend

  stateManager: null
  buildScreenView: null
  track: null

  init: ->
    @publicationView = Build.PublicationView.create
      stateManager: @stateManager
      track: @track

    @buildScreenView.set 'contentView', @publicationView

  publish: ->
    @track.save => Shared.routeManager.set 'location', "play/#{@track.get 'id'}"

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @publicationView.destroy()
