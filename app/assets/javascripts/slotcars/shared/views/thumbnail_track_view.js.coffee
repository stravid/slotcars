
#= require slotcars/shared/views/track_view

TrackView = slotcars.shared.views.TrackView

(namespace 'Slotcars.shared.views').ThumbnailTrackView = TrackView.extend
  
  scaleFactor: 0.3

  didInsertElement: ->
    @_super()

    @$().on 'touchMouseUp', => slotcars.routeManager.set 'location', "play/#{@track.get 'id'}"