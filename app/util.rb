class NSString
  def to_nsurl
    NSURL.URLWithString(self)
  end
end