class PreferencesWindowController < NSWindowController
  def self.sharedInstance
    @instance ||= PreferencesWindowController.alloc.initWithWindowNibName("Preferences")
  end
end
