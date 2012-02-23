
# ------ load basic dependencies -------

#= require jquery
#= require jquery_ujs
#= require ember
#= require helpers/sproutcore/define_sc_namespace

# ------ load testing extras -------
# (jasmine + jasmine-jquery are loaded automatically)

#= require sinon.js
#= require jasmine-sinon.js

# ------ load all specs ------
#= require_tree ./unit
#= require_tree ./functional