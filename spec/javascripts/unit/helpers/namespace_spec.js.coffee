describe 'namespace', ->
  
  it 'should create and return nested objects for namespace string', ->
    returnValue = namespace 'nested.name.space.last'

    (expect nested.name.space.last).toEqual {}
    (expect returnValue).toBe nested.name.space.last