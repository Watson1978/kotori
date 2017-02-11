import Foundation
import Yaml

class SnippetManager: NSObject {

    var items: Yaml!

    func load() {
        let path = Bundle.main.resourcePath! + "/snippet.yml"
        let snippet = try? String(contentsOfFile: path)
        if snippet != nil {
            items = try? Yaml.load(snippet!)
        }
        addMenuItems()
    }

    func addMenuItems() {
        let menu = NSMenu(title: "Snippet")
        let count = Int((items.count)!)
        for i in 0 ..< count {
            let item: Dictionary! = items[i].dictionary
            let title: String = (item["Title"]?.string)!
            if title == "---" {
                menu.addItem(NSMenuItem.separator())
            }
            else {
                menu.addItem(withTitle: title, action: #selector(AppDelegate.selectSnippet(_:)), keyEquivalent: "")
            }
        }
        let menu_item: NSMenuItem! = NSApp.mainMenu?.item(withTitle: "Snippet")
        menu_item.submenu = menu
    }

    func getText(at index: Int) -> String {
        let item: Dictionary! = items[index].dictionary
        var text = (item["Text"]?.string)!;
        text = text.replacingOccurrences(of: "\n", with: "\\n")
        return text;
    }
}
