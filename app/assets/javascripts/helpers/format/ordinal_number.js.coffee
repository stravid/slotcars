Shared.ordinalNumber = (number) ->
  ending = ["th","st","nd","rd"]
  value = number % 100

  number + (ending[(value-20) % 10] || ending[value] || ending[0])