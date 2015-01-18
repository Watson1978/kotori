class AppDelegate
  extend IB
  outlet :window, NSWindow
  outlet :webView, WebView

  def awakeFromNib
    NSApp.delegate = self    
    request = NSURLRequest.requestWithURL("https://esa.io/".to_nsurl)
    webView.mainFrame.loadRequest(request)
  end

  def applicationShouldHandleReopen(application, hasVisibleWindows:flag)
    window.makeKeyAndOrderFront(nil)
    true
  end

  # actions
  def showHelp(sender)
    NSWorkspace.sharedWorkspace.openURL("https://docs.esa.io/".to_nsurl)
  end
end
