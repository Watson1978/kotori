import Cocoa
import WebKit

class Document: NSDocument, WKNavigationDelegate, WKUIDelegate {

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

    func makeWindowControllersOnly() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    func makeWindowControllers(withURLString url: String) {
        makeWindowControllersOnly()
        let viewController : ViewController = self.windowControllers.first!.contentViewController as! ViewController
        viewController.load(withURLString: url)
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
}

