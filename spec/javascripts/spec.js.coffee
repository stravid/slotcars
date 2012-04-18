
# ------ load basic dependencies -------

#= require jquery
#= require jquery_ujs
#= require embient/ember

# ------ load testing extras -------
# (jasmine + jasmine-jquery are loaded automatically)

#= require sinon
#= require jasmine-sinon
#= require_tree ./helpers

#= require namespaces

#= require helpers/namespace
#= require_tree ../../app/assets/javascripts/helpers
#= require_tree ../../app/assets/javascripts/slotcars

# ------ load all specs ------
#= require_tree ./unit