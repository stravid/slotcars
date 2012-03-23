
(namespace 'helpers.routing').routeLocalLinks = (routeManager) ->

  (jQuery 'a.js-route').live 'click', (event) ->
    href = (jQuery this).attr 'href'
    unless href.match /^(http|https):\/\//
      event.preventDefault()
      routeManager.set 'location', href