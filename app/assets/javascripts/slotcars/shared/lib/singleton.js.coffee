
Shared.Singleton = Ember.Object.extend()

# reopenClass is used here to inherit the class methods (static) and attributes
# also to subclasses. Inside the class methods 'this' points to the class itself.
Shared.Singleton.reopenClass

  instance: null

  # all subclasses will have their own singleton @instance because
  # 'this' points to the class that 'getInstance' is called on.
  getInstance: -> if @instance? then @instance else @instance = @create()