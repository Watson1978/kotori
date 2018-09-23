platform :osx, '10.10'
use_frameworks!

target 'kotori' do
  pod 'Sparkle'
  pod 'Yaml'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_HARDENED_RUNTIME'] = "YES"
    end
  end
end