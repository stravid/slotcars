
#= require helpers/namespace

describe 'namespace', ->
  
  it 'should create nested objects for namespace string', ->
    namespace('nested.objects.test')
    
    (expect nested.objects.test).toEqual {}