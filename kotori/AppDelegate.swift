import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(macOS 10.12, *) {
        }
        else {
            // "New Tab" menu is not available with OS X 10.11 or below
            let mainMenu = NSApp.mainMenu
            let fileMenu = mainMenu!.item(at:1)!.submenu!
            for menu in fileMenu.items {
                if menu.title == "New Tab" {
                    fileMenu.removeItem(menu)
                    break
                }
            }
        }
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

    private func openNewDocument() -> Document {
        return try! NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as! Document
    }

    // MARK: Actions
    @IBAction func showPreferencesWindow(sender: Any) {
        let preferences = PreferencesWindowController.sharedInstance
        preferences.showWindow(sender)
    }

    @available(macOS 10.12, *)
    @IBAction func newDocumentAsTab(sender: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers()

        doc.windowControllers.first?.window?.tabbingMode = .preferred
        doc.showWindows()
    }

    @IBAction func showNewPost(sender: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "posts/new")
        doc.showWindows()
    }

    @IBAction func showHome(sender: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "")
        doc.showWindows()
    }

    @IBAction func showPosts(sender: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "posts")
        doc.showWindows()
    }

    @IBAction func showTeam(sender: Any) {
        let doc = openNewDocument()
        doc.makeWindowControllers(withPageName: "team")
        doc.showWindows()
    }

    @IBAction func showMarkdownHelp(sender : Any) {
        let url = URL(string: "https://docs.esa.io/posts/49")!
        NSWorkspace.shared().open(url)
    }

    @IBAction func resetZoom(_ sender: Any) {
        let viewController: ViewController = NSApp.mainWindow?.windowController?.contentViewController as! ViewController
        let webView = viewController.webView
        UserDefaults.standard.set(1.0, forKey: "textZoomFactor")
        webView!.setTextZoomFactor(1.0)
    }

    @IBAction func zoomIn(_ sender: Any) {
        let viewController: ViewController = NSApp.mainWindow?.windowController?.contentViewController as! ViewController
        let webView = viewController.webView
        let factor = webView!.textZoomFactor() + 0.05
        UserDefaults.standard.set(factor, forKey: "textZoomFactor")
        webView!.setTextZoomFactor(factor)
    }

    @IBAction func zoomOut(_ sender: Any) {
        let viewController: ViewController = NSApp.mainWindow?.windowController?.contentViewController as! ViewController
        let webView = viewController.webView
        let factor = webView!.textZoomFactor() - 0.05
        UserDefaults.standard.set(factor, forKey: "textZoomFactor")
        webView!.setTextZoomFactor(factor)
    }
}
