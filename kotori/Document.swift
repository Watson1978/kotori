import Cocoa
import WebKit

class Document: NSDocument, WebFrameLoadDelegate, WebUIDelegate, WebPolicyDelegate {
    
    var windowController : NSWindowController!

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return false
    }
    
    override var isDocumentEdited: Bool {
        get { return false }
    }
    
    private func makeWindowControllers(withURLString url: String) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        loadWebView(getWebView(in: windowController), url: url)
        self.addWindowController(windowController)
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let url = getStartPage()
        makeWindowControllers(withURLString: url)
    }

    func makeWindowControllers(withPageName page: String) {
        // Returns the Storyboard that contains your Document window.
        let url = getStartPage() + page
        makeWindowControllers(withURLString: url)
    }

    // MARK: Private
    private func getStartPage() -> String {
        var url = UserDefaults.standard.string(forKey: "startPage") ?? "https://esa.io/"
        if !url.hasSuffix("/") {
            url += "/"
        }
        return url
    }
    
    private func getWebView(in windowController: NSWindowController) -> WebView {
        return windowController.contentViewController?.view as! WebView
    }

    private func loadWebView(_ webView: WebView!, request: URLRequest!, delegate: Document) {
        webView.frameLoadDelegate = delegate
        webView.uiDelegate = delegate
        webView.policyDelegate = delegate
        webView.mainFrame.load(request)
    }

    private func loadWebView(_ webView: WebView, url: String) {
        let request = URLRequest(url: URL(string: url)!)
        loadWebView(webView, request: request, delegate: self)
    }
    
    // MARK: Delegate - Called when the page title of a frame loads or changes.
    func webView(_ sender: WebView!, didReceiveTitle title: String!, for frame: WebFrame!) {
        if sender.mainFrame == frame {
            windowController?.window?.title = title
        }
    }

    func webView(_ sender: WebView!, createWebViewWith request: URLRequest!) -> WebView? {
        let doc = try! NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as! Document

        doc.makeWindowControllers()
        let webView = getWebView(in: doc.windowController)
        loadWebView(webView, request: request, delegate: doc)
        doc.showWindows()
        return webView
    }
    
    func webView(_ webView: WebView!, decidePolicyForNewWindowAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, newFrameName frameName: String!, decisionListener listener: WebPolicyDecisionListener!) {
        let doc = try! NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as! Document

        doc.makeWindowControllers()
        loadWebView(getWebView(in: doc.windowController), request: request, delegate: doc)
        doc.showWindows()        
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
        if alert.runModal() == NSAlertFirstButtonReturn {
            return true
        }
        return false
    }
}

