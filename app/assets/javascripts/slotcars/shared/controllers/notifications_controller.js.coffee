Shared.NotificationsController = Ember.Object.extend

  pusher: null
  slotcarsChannel: null
  displayedNotification: null

  init: ->
    # disable notifications for testing
    # yes, this is a very bad way of doing this
    return unless Pusher?

    @set 'pusher', new Pusher PUSHER_KEY
    @set 'slotcarsChannel', (@get 'pusher').subscribe 'slotcars'

    (@get 'slotcarsChannel').bind 'new-run', (run) => @_onNewRunEvent run

    # view = Shared.NewRunNotificationView.create
    #   username: 'forknore'
    #   track_id: 17
    #   time: 1234355

    # view.append()

  _onNewRunEvent: (run) ->
    (@get 'displayedNotification').remove() if (@get 'displayedNotification')?

    newNotification = Shared.NewRunNotificationView.create
      username: run.username
      track_id: run.track_id
      time: run.time

    newNotification.append()
    @set 'displayedNotification', newNotification