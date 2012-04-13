
#= require slotcars/account/views/account_widget_view

describe 'Slotcars.account.views.AccountWidgetView', ->

  AccountWidgetView = Slotcars.account.views.AccountWidgetView

  it 'should be an ember view', ->
    (expect AccountWidgetView).toExtend Ember.View

  it 'should use account widget view template', ->
    accountWidgetView = AccountWidgetView.create()

    (expect accountWidgetView.get 'templateName').toBe 'slotcars_account_templates_account_widget_view_template'

  it 'should provide widget location for main content', ->
    accountWidgetView = AccountWidgetView.create()

    testWidgetView = Ember.View.create()
    container = jQuery '<div>'

    accountWidgetView.set 'content', testWidgetView
    accountWidgetView.appendTo container

    Ember.run.end()

    (expect accountWidgetView.$()).toContain testWidgetView.$()