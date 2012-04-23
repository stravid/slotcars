
describe 'Shared.Singleton', ->

  ClassThatExtendsSingleton = Shared.Singleton.extend()

  it 'should inherit a method to always retrieve the same instance', ->
    firstInstance = ClassThatExtendsSingleton.getInstance()
    secondInstance = ClassThatExtendsSingleton.getInstance()

    (expect firstInstance).toBeInstanceOf ClassThatExtendsSingleton
    (expect secondInstance).toBe firstInstance