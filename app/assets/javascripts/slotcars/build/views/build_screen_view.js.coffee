
#= require helpers/namespace
#= require embient/ember-layout
#= require slotcars/build/templates/build_screen_view_template

namespace 'slotcars.build.views'

slotcars.build.views.BuildScreenView = Ember.View.extend

  templateName: 'slotcars_build_templates_build_screen_view_template'
  contentView: null