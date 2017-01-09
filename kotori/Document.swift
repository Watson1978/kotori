import Cocoa
import WebKit

class Document: NSDocument, WebFrameLoadDelegate, WebUIDelegate {
    
    var windowController : NSWindowController!

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return false
    }
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController

        let page = getStartPage()
        loadWebView(getWebView(in: windowController), url: page)
        self.addWindowController(windowController)
    }
    
    func loadURL(suffix : String) {
        let page = getStartPage() + suffix
        loadWebView(getWebView(in: windowController), url: page)
    }

    // MARK: Private
    private func getStartPage() -> String {
        var url = UserDefaults.standard.string(forKey: "startPage") ?? "https://esa.io/"
        if !url.hasSuffix("/") {
            url += "/"
        }
        return url
    }
    
    private func getWebView(in windowController : NSWindowController) -> WebView {
        return windowController.contentViewController?.view as! WebView
    }

    private func loadWebView(_ webView : WebView, url : String) {
        let request = URLRequest(url: URL(string: url)!)
        webView.frameLoadDelegate = self
        webView.uiDelegate = self
        webView.mainFrame.load(request)
    }
    
    // MARK: Delegate - Called when the page title of a frame loads or changes.
    func webView(_ sender: WebView!, didReceiveTitle title: String!, for frame: WebFrame!) {
        windowController?.window?.title = title
    }

    func webView(_ sender: WebView!, runJavaScriptAlertPanelWithMessage message: String!, initiatedBy frame: WebFrame!) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = NSAlertStyle.warning
        alert.runModal()
    }

    func webView(_ sender: WebView!, runJavaScriptConfirmPanelWithMessage message: String!, initiatedBy frame: WebFrame!) -> Bool {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = NSAlertStyle.warning
        if (alert.runModal() == NSAlertFirstButtonReturn) {
            return true
        }
        return false
    }
}

