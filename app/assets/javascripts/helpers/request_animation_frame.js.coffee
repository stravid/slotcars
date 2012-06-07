(->
  lastTime = 0
  vendors = ['ms', 'moz', 'webkit', 'o']
  for vendor in vendors when !window.requestAnimationFrame
    window.requestAnimationFrame = window[vendor+'RequestAnimationFrame']
    window.cancelAnimationFrame = window[vendor+'CancelAnimationFrame'] || window[vendor+'CancelRequestAnimationFrame']

  if !window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max 0, 16 - (currTime - lastTime)
      id = window.setTimeout (-> callback currTime + timeToCall), timeToCall
      lastTime = currTime + timeToCall
      return id

  window.cancelAnimationFrame = (id) -> clearTimeout id unless window.cancelAnimationFrame
)()
