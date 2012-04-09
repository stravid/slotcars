
(namespace 'Slotcars.shared.components').Widget = Ember.Mixin.create

  view: Ember.required()

  addToContainerAtLocation: (container, location) -> container.addViewAtLocation @view, location