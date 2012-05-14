Build.Publisher = Ember.Object.extend

  stateManager: null
  buildScreenView: null
  track: null

  init: ->
    if Shared.User.current?
      @setupPublicationView()
    else
      @setupAuthorizationView()

  setupPublicationView: ->
    @publicationView = Build.PublicationView.create
      stateManager: @stateManager
      track: @track

    @buildScreenView.set 'contentView', @publicationView

  setupAuthorizationView: ->
    @authorizationView = Build.AuthorizationView.create
      stateManager: @stateManager
      delegate: this

    @buildScreenView.set 'contentView', @authorizationView

  signedIn: -> @setupPublicationView()

  signedUp: -> @setupPublicationView()

  publish: ->
    @track.save => Shared.routeManager.set 'location', "play/#{@track.get 'id'}"

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @publicationView.destroy() if @publicationView?
    @authorizationView.destroy() if @authorizationView?
