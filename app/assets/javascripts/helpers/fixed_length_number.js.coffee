Shared.fixedLengthNumber = (number, length = 2) ->
  string = '' + number

  string = '0' + string while string.length < length

  string.substring 0, 2