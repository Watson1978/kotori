class AppDelegate
  extend IB
  outlet :webView, WebView

  def awakeFromNib
    request = NSURLRequest.requestWithURL("https://esa.io/".to_nsurl)
    webView.mainFrame.loadRequest(request)
  end
end
