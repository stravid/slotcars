
(namespace 'Slotcars.shared.components').Container = Ember.Mixin.create

  view: Ember.required()

  addViewAtLocation: (view, location) -> @view.set location, view