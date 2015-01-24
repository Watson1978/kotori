class PreferencesWindow < NSWindow
  def cancelOperation(sender)
    # close Preferences window when press ESC key
    self.close
  end
end