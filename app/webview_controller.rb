class WebViewController
  attr_accessor :webView, :progress

  def initWithWebView(webView)
    @webView = webView
    @webView.UIDelegate = self
    @webView.frameLoadDelegate = self
    @webView.setMaintainsBackForwardList(false)
    version = NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleShortVersionString")
    @webView.customUserAgent = "kotori #{version}"

    self
  end

  def loadURL(url)
    request = NSURLRequest.requestWithURL(url.to_nsurl)
    webView.mainFrame.loadRequest(request)
  end

  def currentURL
    webView.mainFrameURL
  end

  def configureProgress(progress)
    @progress = progress
    nc = NSNotificationCenter.defaultCenter
    nc.addObserver(self, selector:"startLoading:", name:WebViewProgressStartedNotification, object:nil)
    nc.addObserver(self, selector:"progressLoading:", name:WebViewProgressEstimateChangedNotification, object:nil)
    nc.addObserver(self, selector:"finishedLoading:", name:WebViewProgressFinishedNotification, object:nil)
  end

  def startLoading(notification)
    progress.startAnimation(nil)
  end

  def progressLoading(notification)
    progress.setDoubleValue(webView.estimatedProgress)
  end

  def finishedLoading(notification)
    progress.stopAnimation(nil)
  end

  # delegate methods
  def webView(sender, createWebViewWithRequest:request)
    sender.mainFrame.loadRequest(request)
    sender
  end

  def webView(sender, didReceiveTitle:title, forFrame:frame)
    NSApp.delegate.window.title = title
  end

  def webView(sender, runJavaScriptAlertPanelWithMessage:message, initiatedByFrame:frame)
    alert = NSAlert.new.tap do |v|
      v.messageText = message
      v.addButtonWithTitle("OK")
      v.alertStyle = NSWarningAlertStyle
    end
    alert.runModal
  end

  def webView(sender, runJavaScriptConfirmPanelWithMessage:message, initiatedByFrame:frame)
    alert = NSAlert.new.tap do |v|
      v.messageText = message
      v.addButtonWithTitle("OK")
      v.addButtonWithTitle("Cancel")
      v.alertStyle = NSWarningAlertStyle
    end
    alert.runModal == NSAlertFirstButtonReturn ? true : false
  end
end