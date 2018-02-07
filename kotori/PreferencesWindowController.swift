import Cocoa

class PreferencesWindowController: NSWindowController {
    static let shared = PreferencesWindowController(windowNibName: NSNib.Name(rawValue: "Preferences"))
}
