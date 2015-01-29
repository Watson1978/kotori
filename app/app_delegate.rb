class AppDelegate
  extend IB
  outlet :window, NSWindow
  outlet :webView, WebView
  outlet :progress, NSProgressIndicator

  UserDefaults = NSUserDefaults.standardUserDefaults

  def awakeFromNib
    UserDefaults["startPage"] ||= "https://esa.io/"

    webView.UIDelegate = self
    webView.setMaintainsBackForwardList(false)
    version = NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleShortVersionString")
    webView.customUserAgent = "kotori #{version}"

    nc = NSNotificationCenter.defaultCenter
    nc.addObserver(self, selector:"startLoading:", name:WebViewProgressStartedNotification, object:nil)
    nc.addObserver(self, selector:"progressLoading:", name:WebViewProgressEstimateChangedNotification, object:nil)
    nc.addObserver(self, selector:"finishedLoading:", name:WebViewProgressFinishedNotification, object:nil)

    loadURL(UserDefaults["startPage"])
  end

  def applicationShouldHandleReopen(application, hasVisibleWindows:flag)
    window.makeKeyAndOrderFront(nil)
    true
  end

  def applicationShouldTerminate(application)
    return true if UserDefaults["confirmQuitting"] == false

    alert = NSAlert.new.tap do |v|
      v.messageText = "Quit kotori?"
      v.addButtonWithTitle("OK")
      v.addButtonWithTitle("Cancel")
      v.alertStyle = NSWarningAlertStyle
    end

    alert.runModal == NSAlertFirstButtonReturn ? true : false
  end

  def webView(sender, createWebViewWithRequest:request)
    sender.mainFrame.loadRequest(request)
    sender
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

  def startLoading(notification)
    progress.startAnimation(nil)
  end

  def progressLoading(notification)
    progress.setDoubleValue(webView.estimatedProgress)
  end

  def finishedLoading(notification)
    progress.stopAnimation(nil)
  end

  def currentURL
    webView.mainFrameURL
  end

  # actions
  def showNewPost(sender)
    team = teamName
    return unless team
    loadURL("https://#{team}.esa.io/posts/new")
  end

  def showHome(sender)
    team = teamName
    return unless team
    loadURL("https://#{team}.esa.io/")
  end

  def showPosts(sender)
    team = teamName
    return unless team
    loadURL("https://#{team}.esa.io/posts")
  end

  def showTeam(sender)
    team = teamName
    return unless team
    loadURL("https://#{team}.esa.io/team")
  end

  def showHelp(sender)
    NSWorkspace.sharedWorkspace.openURL("https://docs.esa.io/".to_nsurl)
  end

  def showPreferencesWindow(sender)
    preferences = PreferencesWindowController.sharedInstance
    preferences.delegate = self
    preferences.showWindow(sender)
  end

  private

  def loadURL(url)
    request = NSURLRequest.requestWithURL(url.to_nsurl)
    webView.mainFrame.loadRequest(request)
  end

  def teamName
    url = currentURL
    if url =~ /https:\/\/(.+)\.esa\.io/
      return $1
    end
    nil
  end
end
