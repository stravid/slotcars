#= require slotcars/shared/lib/appendable

Play.PlayScreenNotificationsView = Ember.ContainerView.extend

  elementId: 'play-screen-notifications-view'

  controller: null
  notificationsQueue: null
  maximumNumberOfDisplayedNotifications: 3

  didInsertElement: ->
    @set 'notificationsQueue', []

    (@get 'controller').on 'newRunOnCurrentTrack', this, '_onNewRunOnCurrentTrack'

  _onNewRunOnCurrentTrack: (run) ->
    notification = Play.NewRunOnCurrentTrackNotificationView.create
      delegate: this
      username: run.username
      time: run.time

    if (@get 'childViews').length < @get 'maximumNumberOfDisplayedNotifications'
      @_displayNotification notification
    else
      @_queueNotification notification

  _queueNotification: (notification) ->
    (@get 'notificationsQueue').unshift notification

  _displayNotification: (notification) ->
    (@get 'childViews').unshiftObject notification

  removeOldestNotification: ->
    (@get 'childViews').popObject()

    @_displayOldestQueuedNotification() if (@get 'notificationsQueue').length > 0

  _displayOldestQueuedNotification: ->
    @_displayNotification (@get 'notificationsQueue').pop()