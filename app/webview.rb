class CustomWebView < WebView
  def keyDown(event)
    # ESC キーとか、キーボードショートカットに対応していないキーが押されるとアラート音がしてやかましいので、
    # FirstResponder をセットして対応。

    # NSLog event.description
  end
end