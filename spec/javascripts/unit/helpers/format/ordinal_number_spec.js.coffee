
describe 'Shared.ordinalNumber', ->

  it 'should return numbers with ending "st"', ->
    (expect Shared.ordinalNumber 1).toBe '1st'
    (expect Shared.ordinalNumber 21).toBe '21st'

  it 'should return numbers with ending "nd"', ->
    (expect Shared.ordinalNumber 2).toBe '2nd'
    (expect Shared.ordinalNumber 32).toBe '32nd'

  it 'should return numbers with ending "rd"', ->
    (expect Shared.ordinalNumber 3).toBe '3rd'
    (expect Shared.ordinalNumber 43).toBe '43rd'

  it 'should corractly handle numbers with ending "th"', ->
    (expect Shared.ordinalNumber 11).toBe '11th'
    (expect Shared.ordinalNumber 12).toBe '12th'
    (expect Shared.ordinalNumber 13).toBe '13th'