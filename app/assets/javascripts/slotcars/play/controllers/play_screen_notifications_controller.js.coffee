Play.PlayScreenNotificationsController = Ember.Object.extend Ember.Evented,

  trackId: null

  pusher: null
  channel: null

  init: ->
    @_connect()
    @_setupBindings()

  _setupBindings: ->
    (@get 'channel').bind 'new-run', (run) => @_onNewRunEvent run

  _connect: ->
    @set 'pusher', new Pusher PUSHER_KEY
    @set 'channel', (@get 'pusher').subscribe 'slotcars'

  _onNewRunEvent: (run) ->
    return unless run.track_id is @get 'trackId'

    @fire 'newRunOnCurrentTrack', run

  destroy: ->
    (@get 'pusher').disconnect()