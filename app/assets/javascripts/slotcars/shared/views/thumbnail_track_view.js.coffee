
#= require slotcars/shared/views/track_view

TrackView = slotcars.shared.views.TrackView

(namespace 'Slotcars.shared.views').ThumbnailTrackView = TrackView.extend

  scaleFactor: 0.38
  drawTrackOnDidInsertElement: true

  didInsertElement: ->
    @_super()

    @$().on 'touchMouseUp', => slotcars.routeManager.set 'location', "play/#{@track.get 'id'}"