#= require helpers/namespace
#= require community/templates/build_template
#= require builder/builder_application

namespace 'community.views'

community.views.BuildView = Ember.View.extend

  elementId: 'build-view'
  templateName: 'community_templates_build_template'

  builderApplication: builder.BuilderApplication
