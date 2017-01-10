import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: Delegate - Sent to notify the delegate that the application is about to terminate.
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        let confirm_terminate = UserDefaults.standard.bool(forKey: "confirmQuitting")
        if confirm_terminate == false {
            return NSApplicationTerminateReply.terminateNow
        }

        let alert = NSAlert()
        alert.messageText = "Quit kotori?"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = NSAlertStyle.warning
        if alert.runModal() == NSAlertFirstButtonReturn {
            return NSApplicationTerminateReply.terminateNow
        }
        return NSApplicationTerminateReply.terminateCancel
    }

    private func openNewDocument() -> Document? {
        do {
            return try (NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as? Document)
        }
        catch {
            return nil
        }
    }

    // MARK: Actions
    @IBAction func showPreferencesWindow(sender: Any?) {
        let preferences = PreferencesWindowController.sharedInstance
        preferences.showWindow(sender)
    }

    @available(macOS 10.12, *)
    @IBAction func newDocumentAsTab(sender: Any?) {
        let doc = openNewDocument()
        doc?.makeWindowControllers()
        
        doc?.windowControllers.first?.window?.tabbingMode = .preferred
        doc?.showWindows()
    }

    @IBAction func showNewPost(sender: Any?) {
        let doc = openNewDocument()
        doc?.makeWindowControllers()

        doc?.loadURL(suffix: "posts/new")
        doc?.showWindows()
    }

    @IBAction func showHome(sender: Any?) {
        let doc = openNewDocument()
        doc?.makeWindowControllers()

        doc?.loadURL(suffix: "")
        doc?.showWindows()
    }

    @IBAction func showPosts(sender: Any?) {
        let doc = openNewDocument()
        doc?.makeWindowControllers()

        doc?.loadURL(suffix: "posts")
        doc?.showWindows()
    }

    @IBAction func showTeam(sender: Any?) {
        let doc = openNewDocument()
        doc?.makeWindowControllers()
        
        doc?.loadURL(suffix: "team")
        doc?.showWindows()
    }

    @IBAction func showMarkdownHelp(sender : AnyObject) {
        let url = URL(string: "https://docs.esa.io/posts/49")!
        NSWorkspace.shared().open(url)
    }

}

