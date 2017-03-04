import Cocoa
import WebKit

class Document: NSDocument {

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override var isDocumentEdited: Bool {
        return false
    }

    func makeWindowControllersOnly() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    func makeWindowControllers(withURLString urlString: String) {
        makeWindowControllersOnly()
        if let viewController = windowControllers.first?.contentViewController as? ViewController {
            viewController.load(withURLString: urlString)
        }
    }

    override func makeWindowControllers() {
        let urlString = getStartPage()
        makeWindowControllers(withURLString: urlString)
    }

    func makeWindowControllers(withPageName page: String) {
        let urlString = getStartPage() + page
        makeWindowControllers(withURLString: urlString)
    }

    func setTabbingMode() {
        if #available(macOS 10.12, *) {
            windowControllers.first?.window?.tabbingMode = .preferred
        }
    }

    // MARK: Private
    private func getStartPage() -> String {
        var urlString = UserDefaults.standard.string(forKey: "startPage") ?? "https://esa.io/"
        if !urlString.hasSuffix("/") {
            urlString += "/"
        }
        return urlString
    }
}
