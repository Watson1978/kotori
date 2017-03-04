import Foundation
import Yaml

class SnippetManager: NSObject {

    var items: Yaml!

    func load() {
        guard let resourcePath = Bundle.main.resourcePath else {
            return
        }

        // TODO: Need better code
        let lang = NSLocale.preferredLanguages[0]
        let path: String
        if lang == "ja-JP" {
            path = resourcePath + "/ja.lproj/snippet.yml"
        } else {
            path = resourcePath + "/Base.lproj/snippet.yml"
        }

        do {
            let snippet = try String(contentsOfFile: path)
            let yml = try Yaml.load(snippet)
            items = yml
            addMenuItems()
        } catch let error {
            print("\(error)")
        }
    }

    func addMenuItems() {
        guard let items = items else { return }
        let menu = NSMenu(title: NSLocalizedString("Snippet", comment: ""))
        for i in 0 ..< (items.count ?? 0) {
            let item = items[i].dictionary
            if let title = item?["Title"]?.string {
                if title == "---" {
                    menu.addItem(NSMenuItem.separator())
                } else {
                    menu.addItem(withTitle: title, action: #selector(AppDelegate.selectSnippet(_:)), keyEquivalent: "")
                }
            }
        }
        let menuItem = NSApp.mainMenu?.item(withTag: 333)
        menuItem?.submenu = menu
    }

    func getText(at index: Int) -> String {
        let item = items[index].dictionary
        guard var text = item?["Text"]?.string else {
            return ""
        }
        text = text.replacingOccurrences(of: "\n", with: "\\n")
        text = text.replacingOccurrences(of: "\t", with: "\\t")
        return text
    }
}
