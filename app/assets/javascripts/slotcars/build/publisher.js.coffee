
#= require slotcars/build/views/publication_view

PublicationView = Slotcars.build.views.PublicationView

(namespace 'Slotcars.build').Publisher = Ember.Object.extend

  stateManager: null
  buildScreenView: null
  track: null

  init: ->
    @publicationView = PublicationView.create
      stateManager: @stateManager
      track: @track

    @buildScreenView.set 'contentView', @publicationView

  publish: ->
    @track.save()

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @publicationView.destroy()
