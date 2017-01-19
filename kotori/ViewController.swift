import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {
    var webView: WKWebView!

    deinit {
        webView.removeObserver(self, forKeyPath: "title", context: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        webView.frame = self.view.frame
        webView.autoresizingMask = NSAutoresizingMaskOptions(arrayLiteral: .viewWidthSizable, .viewHeightSizable)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)

        var factor = UserDefaults.standard.double(forKey: "textZoomFactor")
        if factor == 0.0 {
            // If cannot retrieve value of textZoomFactor, use 1.0 as default value.
            factor = 1.0
        }
        webView.setTextZoomFactor(factor)
        self.view.addSubview(webView)
    }

    func load(withRequest request: URLRequest) {
        webView.load(request)
    }

    func load(withURLString url: String) {
        let request = URLRequest(url: URL(string: url)!)
        load(withRequest: request)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            self.view.window!.title = webView.title ?? ""
        }
    }

    // MARK: Delegate - Called when the page title of a frame loads or changes.
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        NSWorkspace.shared().open(navigationAction.request.url!)
        return nil
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
