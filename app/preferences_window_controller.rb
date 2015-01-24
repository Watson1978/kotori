class PreferencesWindowController < NSWindowController
  attr_accessor :delegate

  def self.sharedInstance
    @instance ||= PreferencesWindowController.alloc.initWithWindowNibName("Preferences")
  end

  # actions
  def setCurrentAsStartPage(sender)
    defaluts = NSUserDefaults.standardUserDefaults
    defaluts["startPage"] = delegate.currentURL
  end
end
