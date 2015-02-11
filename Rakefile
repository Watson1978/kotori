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
  app.version = '0.7'
  app.identifier = 'jp.cat-soft.kotori'
  app.deployment_target = '10.8'
  app.codesign_certificate = 'Developer ID Application: Shizuo Fujita (KQ572MNR73)'
  app.info_plist['NSMainNibFile'] = 'MainMenu'
  app.info_plist['CFBundleIconFile'] = 'kotori.icns'
  app.frameworks << 'WebKit'

  app.release do
    app.info_plist['SUFeedURL'] = 'https://raw.githubusercontent.com/Watson1978/kotori/master/sparkle.xml'
    app.info_plist['SUEnableAutomaticChecks'] = true
    app.info_plist['SUScheduledCheckInterval'] = 86400 # 24hrs * 60mins/hr * 60sec/min
    app.embedded_frameworks << 'vendor/Sparkle.framework'
  end
end

namespace :gen do
  desc "Generate kotori.icns file"
  task :icns do
    sh "iconutil --convert icns kotori.iconset"
    sh "mv kotori.icns resources/"
  end
end

namespace :archive do
  desc "Generate kotori.dmg to release"
  task :dmg => [:"build:release"] do
    config = Motion::Project::App.config
    dmg_name = "#{config.name}_#{config.version}"
    sh "rsync -a build/MacOSX-#{config.deployment_target}-Release/#{config.name}.app build/Release"
    sh "ln -sf /Applications build/Release"
    sh "hdiutil create build/tmp.dmg -volname #{dmg_name} -srcfolder build/Release"
    sh "hdiutil convert -format UDBZ build/tmp.dmg -o build/#{dmg_name}.dmg"
    sh "rm -f build/tmp.dmg"
  end
end