import Cocoa
import WebKit

class Document: NSDocument, WKNavigationDelegate, WKUIDelegate {
    
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
        windowController.window!.contentView = WKWebView()
        loadWebView(getWebView(in: windowController), url: url)
        self.addWindowController(windowController)
    }

    private func makeWindowControllers(withURLString url: String, withConfiguration configuration: WKWebViewConfiguration) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        windowController.window!.contentView = WKWebView(frame: windowController.window!.frame as CGRect!, configuration: configuration)
        loadWebView(getWebView(in: windowController), url: url)
        self.addWindowController(windowController)
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let url = getStartPage()
        makeWindowControllers(withURLString: url)
    }

    func makeWindowControllers(withConfiguration configuration: WKWebViewConfiguration) {
        // Returns the Storyboard that contains your Document window.
        let url = getStartPage()
        makeWindowControllers(withURLString: url, withConfiguration: configuration)
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
    
    private func getWebView(in windowController: NSWindowController) -> WKWebView {
        return windowController.window!.contentView as! WKWebView
    }

    private func loadWebView(_ webView: WKWebView!, request: URLRequest!, delegate: Document) {
        webView.navigationDelegate = delegate
        webView.uiDelegate = delegate
        webView.load(request)
    }

    private func loadWebView(_ webView: WKWebView, url: String) {
        let request = URLRequest(url: URL(string: url)!)
        loadWebView(webView, request: request, delegate: self)
    }
    
    // MARK: Delegate - Called when the page title of a frame loads or changes.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        windowController.window!.title = webView.title ?? ""
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let doc = try! NSDocumentController.shared().openUntitledDocumentAndDisplay(false) as! Document

        doc.makeWindowControllers(withConfiguration: configuration)
        let webView = getWebView(in: doc.windowController)
        loadWebView(webView, request: navigationAction.request, delegate: doc)
        doc.showWindows()
        return webView
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = NSAlertStyle.warning
        alert.runModal()
        completionHandler()
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = NSAlertStyle.warning
        if alert.runModal() == NSAlertFirstButtonReturn {
            return completionHandler(true)
        }
        return completionHandler(false)
    }
}

