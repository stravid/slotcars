
#= require slotcars/account/templates/profile_view_template

(namespace 'Slotcars.account.views').ProfileView = Ember.View.extend

  delegate: null
  elementId: 'profile-widget-view'
  templateName: 'slotcars_account_templates_profile_view_template'

  user: null