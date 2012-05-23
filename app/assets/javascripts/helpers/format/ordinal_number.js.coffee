Shared.ordinalNumber = (number) ->
  endings = ["th","st","nd","rd"]
  value = number % 100

  number + (endings[(value-20) % 10] || endings[value] || endings[0])