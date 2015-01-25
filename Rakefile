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
  app.version = '0.6'
  app.identifier = 'jp.cat-soft.kotori'
  app.deployment_target = '10.8'
  app.codesign_certificate = '3rd Party Mac Developer Application: Shizuo Fujita (KQ572MNR73)'
  app.info_plist['NSMainNibFile'] = 'MainMenu'
  app.info_plist['CFBundleIconFile'] = 'kotori.icns'
  app.frameworks << 'WebKit'

  app.release do
    app.info_plist['SUFeedURL'] = 'https://raw.githubusercontent.com/Watson1978/kotori/master/sparkle.xml'
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
  desc "Generate kotori.zip to release"
  task :zip => [:"build:release"] do
    config = Motion::Project::App.config
    zip_name = "#{config.name}_#{config.version}.zip"
    sh "rsync -a build/MacOSX-#{config.deployment_target}-Release/#{config.name}.app build/Release"
    Dir.chdir("build/Release") do
      sh "zip -r #{zip_name} #{config.name}.app"
    end
  end
end