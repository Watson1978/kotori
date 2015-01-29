class WebViewDelegate
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
end