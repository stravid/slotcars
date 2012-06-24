Tracks.PageView = Ember.View.extend

  templateName: 'slotcars_tracks_templates_page_view_template'
  classNames: ['page']

  origin: null
  tracksController: null

  didInsertElement: ->
    @moveToOrigin()

    @$().css 'position', 'absolute'

  moveTo: (offset) ->
    @$().css '-webkit-transform', "translate3d(#{@origin + offset}px,0,0)"
    @$().css '-moz-transform', "translate3d(#{@origin + offset}px,0,0)"
    @$().css '-o-transform', "translate(#{@origin + offset}px,0)"

  setOrigin: (origin) -> @set 'origin', origin

  disableTransitions: ->
    @$().css '-webkit-transition', ''
    @$().css '-moz-transition', ''
    @$().css '-o-transition', ''

  enableTransitions: ->
    @$().css '-webkit-transition', '-webkit-transform 0.2s ease-in-out'
    @$().css '-moz-transition', '-moz-transform 0.2s ease-in-out'
    @$().css '-o-transition', '-o-transform 0.2s ease-in-out'

  moveToOrigin: -> @moveTo 0
