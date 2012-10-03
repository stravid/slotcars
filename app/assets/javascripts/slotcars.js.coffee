#= require jquery
#= require jquery_ujs

#= require slotcars/slotcars_application

# override Ember.assert in production and development
# this file is no used in test environment
Ember.assert = ->

# override console.warn to prevent Ember deprecation warnings
if window.console
  window.console.nativeWarn = window.console.warn
  window.console.warn = (text) -> unless text.substr(0, 11) == 'DEPRECATION' then console.nativeWarn text

SlotcarsApplication.create()
