class AppDelegate
  extend IB
  outlet :window, NSWindow
  outlet :webView, WebView

  def awakeFromNib
    NSApp.delegate = self    
    webView.setMaintainsBackForwardList(false)

    request = NSURLRequest.requestWithURL("https://esa.io/".to_nsurl)
    webView.mainFrame.loadRequest(request)
  end

  def applicationShouldHandleReopen(application, hasVisibleWindows:flag)
    window.makeKeyAndOrderFront(nil)
    true
  end

  def applicationShouldTerminate(application)
    alert = NSAlert.new.tap do |v|
      v.messageText = "Quit kotori?"
      v.addButtonWithTitle("OK")
      v.addButtonWithTitle("Cancel")
      v.alertStyle = NSWarningAlertStyle
    end

    ret = alert.runModal
    if ret == NSAlertFirstButtonReturn
      true
    else
      false
    end
  end

  # actions
  def showHelp(sender)
    NSWorkspace.sharedWorkspace.openURL("https://docs.esa.io/".to_nsurl)
  end
end
