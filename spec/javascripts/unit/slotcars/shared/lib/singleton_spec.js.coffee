
describe 'Slotcars.shared.lib.Singleton', ->

  Singleton = Slotcars.shared.lib.Singleton
  ClassThatExtendsSingleton = Singleton.extend()

  it 'should inherit a method to always retrieve the same instance', ->
    firstInstance = ClassThatExtendsSingleton.getInstance()
    secondInstance = ClassThatExtendsSingleton.getInstance()

    (expect firstInstance).toBeInstanceOf ClassThatExtendsSingleton
    (expect secondInstance).toBe firstInstance