Build.Publisher = Ember.Object.extend

  stateManager: null
  buildScreenView: null
  track: null
  publicationView: null
  authorizationView: null

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
      track: @track
      delegate: this

    @buildScreenView.set 'contentView', @authorizationView

  signedIn: -> @setupPublicationView()

  signedUp: -> @setupPublicationView()

  publish: ->
    @setTitleOnTrackToPublish()
    @track.save => Shared.routeManager.set 'location', "play/#{@track.get 'id'}"

  setTitleOnTrackToPublish: -> @track.setTitle @publicationView.get 'trackTitle'

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @publicationView.destroy() if @publicationView?
    @authorizationView.destroy() if @authorizationView?
