Shared.FastTriggerable = Ember.Mixin.create

  touchTarget: null

  touchStart: (event) ->
    @touchTarget = event.target

  touchEnd: (event) ->
    if event.target is @touchTarget
      event.preventDefault()

      # triggers 'click' immediately
      (jQuery event.target).trigger 'click'
      @touchTarget = null

      # catches 'ghost click' which is fired by the system
      (jQuery event.target).on 'click', (event) ->
        event.preventDefault()
        event.stopPropagation()

      # releases 'ghost click' handler after 400ms - system triggers after ~300ms
      Ember.run.later (=> (jQuery event.target).off 'click'), 400
