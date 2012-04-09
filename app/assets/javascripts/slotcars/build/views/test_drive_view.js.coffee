
#= require slotcars/build/templates/test_drive_view_template

(namespace 'Slotcars.build.views').TestDriveView = Ember.View.extend

  elementId: 'build-test-drive-view'
  templateName: 'slotcars_build_templates_test_drive_view_template'
  trackView: null
  carView: null

  testDriveController: null

  onEditTrackButtonClicked: (event) ->
    event.preventDefault() if event?
    @testDriveController.onEditTrack()
