import Foundation
import Yaml

class SnippetManager: NSObject {

    var items: Yaml!

    func load() {
        let path = Bundle.main.resourcePath! + "/snippet.yml"
        guard let snippet = try? String(contentsOfFile: path) else {
            return
        }
        guard let yml = try? Yaml.load(snippet) else {
            return
        }
        items = yml
        addMenuItems()
    }

    func addMenuItems() {
        let menu = NSMenu(title: NSLocalizedString("Snippet", comment: ""))
        let count = Int(items.count!)
        for i in 0 ..< count {
            let item: Dictionary! = items[i].dictionary
            if let title = item["Title"]?.string {
                if title == "---" {
                    menu.addItem(NSMenuItem.separator())
                }
                else {
                    menu.addItem(withTitle: title, action: #selector(AppDelegate.selectSnippet(_:)), keyEquivalent: "")
                }
            }
        }
        let menu_item: NSMenuItem! = NSApp.mainMenu!.item(withTag: 333)
        menu_item.submenu = menu
    }

    func getText(at index: Int) -> String {
        let item: Dictionary! = items[index].dictionary
        guard var text = item["Text"]?.string else {
            return ""
        }
        text = text.replacingOccurrences(of: "\n", with: "\\n")
        text = text.replacingOccurrences(of: "\t", with: "\\t")
        return text;
    }
}
