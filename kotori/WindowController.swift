import Cocoa

@available(OSX 10.12.2, *)
class WindowController: NSWindowController {

    @IBAction func saveAsWIP(_ sender: Any) {
        if let mainWindow = NSApp.mainWindow,
            let viewController = mainWindow.windowController?.contentViewController as? ViewController {
            viewController.saveAsWIP()
        }
    }

    @IBAction func ShipIt(_ sender: Any) {
        if let mainWindow = NSApp.mainWindow,
            let viewController = mainWindow.windowController?.contentViewController as? ViewController {
            viewController.shipIt()
        }
    }
}
