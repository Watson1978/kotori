# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'kotori'
  app.version = '0.1'
  app.info_plist['NSMainNibFile'] = 'MainMenu'
  app.info_plist['CFBundleIconFile'] = 'kotori.icns'
  app.frameworks << 'WebKit'
end

namespace :gen do
  desc "Generate kotori.icns file"
  task :icns do
    sh "iconutil --convert icns kotori.iconset"
    sh "mv kotori.icns resources/"
  end
end