VERSION = "0.10"

desc "Generate kotori.dmg to release"
task :archive do
  sh "rm -rf build"

  mkdir_p "build/package"
  settings = `xcodebuild -workspace kotori.xcworkspace -scheme kotori -configuration Release -showBuildSettings`.strip
  build_dir = nil
  settings.lines.map { |x| x.strip }.each do |item|
    m = item.match(/(.+) = (.+)/)
    if m && m[1] == "TARGET_BUILD_DIR"
      build_dir = m[2]
    end
  end

  sh "rm -rf #{build_dir}"
  sh "xcodebuild -workspace kotori.xcworkspace -scheme kotori -configuration Release"

  sh "rsync -a #{build_dir}/kotori.app build/package"

  sh "hdiutil create build/tmp.dmg -volname 'kotori_#{VERSION}' -srcfolder build/package"
  sh "hdiutil convert -format UDBZ build/tmp.dmg -o build/kotori_#{VERSION}.dmg"
  sh "rm -f build/tmp.dmg"
end
