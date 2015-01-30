class AppDelegate
  extend IB
  outlet :window, NSWindow
  outlet :webView, WebView
  outlet :progress, NSProgressIndicator

  UserDefaults = NSUserDefaults.standardUserDefaults

  def awakeFromNib
    UserDefaults["startPage"] ||= "https://esa.io/"
    @webViewController = WebViewController.alloc.initWithWebView(webView)
    @webViewController.configureProgress(progress)

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

  def currentURL
    @webViewController.webView.mainFrameURL
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
    @webViewController.webView.mainFrame.loadRequest(request)
  end

  def teamName
    url = currentURL
    if url =~ /https:\/\/(.+)\.esa\.io/
      return $1
    end
    nil
  end
end
