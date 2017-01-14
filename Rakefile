VERSION = "0.10"

desc "Generate kotori.dmg to release"
task :archive do
  sh "rm -rf build"
  sh "xcodebuild -configuration Release"
  mkdir_p "build/package"
  sh "rsync -a build/Release/kotori.app build/package"

  sh "hdiutil create build/tmp.dmg -volname 'kotori_#{VERSION}' -srcfolder build/package"
  sh "hdiutil convert -format UDBZ build/tmp.dmg -o build/kotori_#{VERSION}.dmg"
  sh "rm -f build/tmp.dmg"
end