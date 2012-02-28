
#= require helpers/namespace

namespace 'shared.mediators'

shared.mediators.currentTrackMediator = Ember.Object.create

  currentTrack: null

  showRoute: (->
    currentTrack = @get 'currentTrack'
    if currentTrack?
      clientId = currentTrack.get 'clientId'
      "tracks/#{clientId}"
    else
      null
  ).property 'currentTrack'
