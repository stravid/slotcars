Build.Editor = Ember.Object.extend

  buildScreenView: null
  track: null

  init: ->
    @_editView = Build.EditView.create
      track: @track

    @buildScreenView.set 'contentView', @_editView

  destroy: ->
    @buildScreenView.set 'contentView', null
    @_editView.destroy()
    @_super()
