
#= require slotcars/home/templates/home_screen_view_template

Home.HomeScreenView = Ember.View.extend

  elementId: 'home_screen_view'
  templateName: 'slotcars_home_templates_home_screen_view_template'

  onTouchMouseMove: (event) ->
    event.originalEvent.preventDefault()

  didInsertElement: ->
    @$(document.body).on 'touchMouseMove', (event) => @onTouchMouseMove(event)
