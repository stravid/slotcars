Tracks.PageView = Ember.View.extend

  templateName: 'slotcars_tracks_templates_page_view_template'
  classNames: [ 'page' ]
  origin: null
  tracksController: null

  didInsertElement: ->
    @moveToOrigin()
    @$().css 'position', 'absolute'
    @$().css 'width', '100%'
    @$('.spinner').spin radius: 13

  moveTo: (offset) -> @$().css '-webkit-transform', "translate3d(#{@origin + offset}px,0,0)"

  setOrigin: (origin) -> @set 'origin', origin

  disableTransitions: -> @$().css '-webkit-transition', ''

  enableTransitions: ->
    @$().css '-webkit-backface-visibility', 'hidden'
    @$().css '-webkit-transition', '-webkit-transform 0.2s ease-in-out'

  moveToOrigin: -> @moveTo 0
