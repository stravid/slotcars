
# ------ load basic dependencies -------

#= require jquery
#= require jquery_ujs
#= require ember

# ------ load testing extras -------
# (jasmine + jasmine-jquery are loaded automatically)

#= require sinon
#= require jasmine-sinon
#= require helpers/jasmine/custom_matchers

# ------ load all specs ------
#= require_tree ./unit
#= require_tree ./functional