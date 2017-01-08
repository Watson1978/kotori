import Cocoa

class PreferencesWindowController : NSWindowController {
    static let sharedInstance: PreferencesWindowController = PreferencesWindowController(windowNibName: "Preferences")
}
