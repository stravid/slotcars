Shared.BaseGameViewContainer = Ember.View.extend

  templateName: 'slotcars_shared_templates_base_game_view_container_template'

  trackView: null
  carView: null
  ghostView: null
  clockView: null
  gameView: null

  destroy: ->
    @trackView.destroy() if @trackView
    @carView.destroy() if @carView
    @clockView.destroy() if @clockView
    @gameView.destroy() if @gameView
    @_super()
