Shared.Button = Ember.Object.extend

  disabled: true
  active: false

  reset: ->
    @set 'disabled', true
    @set 'active', false
