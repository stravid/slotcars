Build.Editor = Ember.Object.extend

  buildScreenView: null
  track: null

  init: ->
    @_editView = Build.EditView.create
      track: @track

    @buildScreenView.set 'contentView', @_editView

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @_editView.destroy()
