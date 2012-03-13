

namespace 'helpers.graphic'

class helpers.graphic.Clock
  
  chars: null
  values: [
    "letter-0"
    "letter-0"
    "letter-0"
    "letter-0"
  ]
    
  findNodes: ->
    @chars = [
      jQuery '#clock-seconds .first'
      jQuery '#clock-seconds .second'
      jQuery '#clock-milliseconds .first'
      jQuery '#clock-milliseconds .second'
    ]
  
  updateTime: (milliSeconds) ->
    console.log milliSeconds
    
    seconds = milliSeconds / 1000
    secondsString = (~~seconds).toString()
    milliSecondString = (~~(milliSeconds / 10)).toString()
    
    firstLetter = if secondsString.length > 1 then secondsString.substr -2, 1 else '0'
    secondLetter = secondsString.substr -1, 1 
    thirdLetter = milliSecondString.substr -2, 1
    fourthLetter = milliSecondString.substr -1, 1
    
    @_setLetters [firstLetter, secondLetter, thirdLetter, fourthLetter]

  _setLetters: (letters) ->
    return unless @chars?
    
    @_removeClasses()
    
    for char, i in @chars
      className = "letter-#{letters[i]}"
      @values[i] = className
      char.addClass className
    

  _removeClasses: ->
    for char, i in @chars
      char.removeClass @values[i]
