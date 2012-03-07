
#= require helpers/namespace
#= require slotcars/tracks/controllers/tracks_controller

namespace 'slotcars.tracks'

slotcars.tracks.TracksScreen = Ember.Object.extend

  appendToApplication: ->
    slotcars.tracks.controllers.TracksController.create()