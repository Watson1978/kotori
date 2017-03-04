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
        appleEventManager.setEventHandler(self, andSelector: #selector(handleGetURLEvent(_:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))

        if #available(macOS 10.12, *) {
        } else {
            // "New Tab" menu is not available with OS X 10.11 or below
            let fileMenu = NSApp.mainMenu?.item(at: 1)?.submenu
            if let newTabMenu = fileMenu?.item(withTag: 111) {
                fileMenu?.removeItem(newTabMenu)
            }
        }
    }

    // MARK: Delegate - Sent to notify the delegate that the application is about to terminate.
    func applicationShouldTerminate(_: NSApplication) -> NSApplicationTerminateReply {
        let confirmTerminate = UserDefaults.standard.bool(forKey: "confirmQuitting")
        if confirmTerminate == false {
            return .terminateNow
        }

        let alert = NSAlert()
        alert.messageText = "Quit kotori?"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        if alert.runModal() == NSAlertFirstButtonReturn {
            return .terminateNow
        }
        return .terminateCancel
    }

    private func openNewDocument() throws -> Document? {
        return try NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as? Document
    }

    // MARK: Actions
    @IBAction func showPreferencesWindow(_ sender: Any) {
        PreferencesWindowController.shared.showWindow(sender)
    }

    @available(macOS 10.12, *)
    @IBAction func newDocumentAsTab(_: Any) {
        do {
            if let doc = try openNewDocument() {
                doc.makeWindowControllers()
                doc.setTabbingMode()
                doc.showWindows()
            }
        } catch let error {
            print("\(error)")
        }
    }

    @IBAction func showNewPost(_: Any) {
        showPage(withPageName: "posts/new")
    }

    @IBAction func showHome(_: Any) {
        showPage()
    }

    @IBAction func showPosts(_: Any) {
        showPage(withPageName: "posts")
    }

    @IBAction func showTeam(_: Any) {
        showPage(withPageName: "team")
    }

    @IBAction func showMarkdownHelp(_: Any) {
        let url = URL(string: "https://docs.esa.io/posts/49")!
        NSWorkspace.shared().open(url)
    }

    @IBAction func resetZoom(_: Any) {
        if let mainWindow = NSApp.mainWindow,
            let viewController = mainWindow.windowController?.contentViewController as? ViewController,
            let webView = viewController.webView {

            UserDefaults.standard.set(1.0, forKey: "textZoomFactor")
            webView.setTextZoomFactor(1.0)
        }
    }

    @IBAction func zoomIn(_: Any) {
        if let mainWindow = NSApp.mainWindow,
            let viewController = mainWindow.windowController?.contentViewController as? ViewController,
            let webView = viewController.webView {

            let factor = webView.textZoomFactor() + 0.05
            UserDefaults.standard.set(factor, forKey: "textZoomFactor")
            webView.setTextZoomFactor(factor)
        }
    }

    @IBAction func zoomOut(_: Any) {
        if let mainWindow = NSApp.mainWindow,
            let viewController = mainWindow.windowController?.contentViewController as? ViewController,
            let webView = viewController.webView {

            let factor = webView.textZoomFactor() - 0.05
            UserDefaults.standard.set(factor, forKey: "textZoomFactor")
            webView.setTextZoomFactor(factor)
        }
    }

    // MARK: Selector
    func handleGetURLEvent(_ event: NSAppleEventDescriptor, replyEvent _: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else {
            return
        }

        do {
            if let doc = try openNewDocument() {
                doc.makeWindowControllers(withURLString: urlString)
                doc.setTabbingMode()
                doc.showWindows()
            }
        } catch let error {
            print("\(error)")
        }
    }

    func selectSnippet(_ sender: AnyObject) {
        guard let menuItem = sender as? NSMenuItem, let index = menuItem.menu?.index(of: menuItem) else {
            return
        }

        if let mainWindow = NSApp.mainWindow,
            let viewController = mainWindow.windowController?.contentViewController as? ViewController {

            viewController.insertTextToTextarea(snippet.getText(at: index))
        }
    }

    // MARK: Private
    private func showPage(withPageName name: String = "") {
        do {
            if let doc = try openNewDocument() {
                doc.makeWindowControllers(withPageName: name)
                doc.setTabbingMode()
                doc.showWindows()
            }
        } catch let error {
            print("\(error)")
        }
    }
}
