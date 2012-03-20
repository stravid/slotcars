
namespace('helpers.routing').routeLocalLinks = (routeManager) ->

  (jQuery 'a').live 'click', (event) ->
    href = (jQuery this).attr 'href'
    unless href.match /^(http|https):\/\//
      event.preventDefault()
      routeManager.set 'location', href