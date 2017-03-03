import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var snippet: SnippetManager!

    func applicationDidFinishLaunching(_: Notification) {
        // Disable smart quotes & dashes in WebView
        UserDefaults.standard.set(false, forKey: "WebAutomaticQuoteSubstitutionEnabled")
        UserDefaults.standard.set(false, forKey: "WebAutomaticDashSubstitutionEnabled")

        snippet.load()

        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))

        if #available(macOS 10.12, *) {
        } else {
            // "New Tab" menu is not available with OS X 10.11 or below
            let mainMenu = NSApp.mainMenu
            let fileMenu = mainMenu!.item(at: 1)!.submenu!
            let newTabMenu = fileMenu.item(withTag: 111)!
            fileMenu.removeItem(newTabMenu)
        }
    }

    // MARK: Delegate - Sent to notify the delegate that the application is about to terminate.
    func applicationShouldTerminate(_: NSApplication) -> NSApplicationTerminateReply {
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

    private func openNewDocument() -> Document {
        return try! NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as! Document
    }

    // MARK: Actions
    @IBAction func showPreferencesWindow(_ sender: Any) {
        let preferences = PreferencesWindowController.sharedInstance
        preferences.showWindow(sender)
    }

    @available(macOS 10.12, *)
    @IBAction func newDocumentAsTab(_: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers()
        doc.setTabbingMode()
        doc.showWindows()
    }

    @IBAction func showNewPost(_: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "posts/new")
        doc.setTabbingMode()
        doc.showWindows()
    }

    @IBAction func showHome(_: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "")
        doc.setTabbingMode()
        doc.showWindows()
    }

    @IBAction func showPosts(_: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "posts")
        doc.setTabbingMode()
        doc.showWindows()
    }

    @IBAction func showTeam(_: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "team")
        doc.setTabbingMode()
        doc.showWindows()
    }

    @IBAction func showMarkdownHelp(_: Any) {
        let url = URL(string: "https://docs.esa.io/posts/49")!
        NSWorkspace.shared().open(url)
    }

    @IBAction func resetZoom(_: Any) {
        if let mainWindow = NSApp.mainWindow {
            let viewController: ViewController = mainWindow.windowController!.contentViewController as! ViewController
            let webView = viewController.webView
            UserDefaults.standard.set(1.0, forKey: "textZoomFactor")
            webView!.setTextZoomFactor(1.0)
        }
    }

    @IBAction func zoomIn(_: Any) {
        if let mainWindow = NSApp.mainWindow {
            let viewController: ViewController = mainWindow.windowController!.contentViewController as! ViewController
            let webView = viewController.webView
            let factor = webView!.textZoomFactor() + 0.05
            UserDefaults.standard.set(factor, forKey: "textZoomFactor")
            webView!.setTextZoomFactor(factor)
        }
    }

    @IBAction func zoomOut(_: Any) {
        if let mainWindow = NSApp.mainWindow {
            let viewController: ViewController = mainWindow.windowController!.contentViewController as! ViewController
            let webView = viewController.webView
            let factor = webView!.textZoomFactor() - 0.05
            UserDefaults.standard.set(factor, forKey: "textZoomFactor")
            webView!.setTextZoomFactor(factor)
        }
    }

    func handleGetURLEvent(_ event: NSAppleEventDescriptor, replyEvent _: NSAppleEventDescriptor) {
        let url_string = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!

        let doc = openNewDocument()
        doc.makeWindowControllers(withURLString: url_string)
        doc.setTabbingMode()
        doc.showWindows()
    }

    func selectSnippet(_ sender: AnyObject) {
        let menu_item: NSMenuItem? = sender as? NSMenuItem
        guard let index = menu_item?.menu?.index(of: menu_item!) else {
            return
        }
        if let mainWindow = NSApp.mainWindow {
            let viewController: ViewController = mainWindow.windowController!.contentViewController as! ViewController
            viewController.insertTextToTextarea(snippet.getText(at: index))
        }
    }
}
