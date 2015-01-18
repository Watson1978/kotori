class AppDelegate
  extend IB
  outlet :webView, WebView

  def awakeFromNib
    request = NSURLRequest.requestWithURL("https://esa.io/".to_nsurl)
    webView.mainFrame.loadRequest(request)
  end

  # actions
  def showHelp(sender)
    NSWorkspace.sharedWorkspace.openURL("https://docs.esa.io/".to_nsurl)
  end
end
