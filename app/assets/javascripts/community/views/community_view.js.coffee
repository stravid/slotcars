
#= require helpers/namespace
#= require embient/ember-layout
#= require community/templates/community_template

namespace 'community.views'

community.views.CommunityView = Ember.View.extend

  elementId: 'community-view'
  templateName: 'community_templates_community_template'

  contentView: null