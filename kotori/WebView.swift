import WebKit

class CustomWebView : WebView {
    override func keyDown(with event: NSEvent) {
        // ESC キーとか、キーボードショートカットに対応していないキーが押されるとアラート音がしてやかましいので
        // keyDown を無効にする
    }
}
