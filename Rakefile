VERSION = `/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" kotori/Info.plist`.strip

desc "Release"
task :release => [:archive, :"update:sparkle"] do
end

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
  sh "ln -sf /Applications build/package"

  sh "hdiutil create build/tmp.dmg -volname 'kotori_#{VERSION}' -srcfolder build/package"
  sh "hdiutil convert -format UDBZ build/tmp.dmg -o build/kotori_#{VERSION}.dmg"
  sh "rm -f build/tmp.dmg"
end


sparkle_template =<<END
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle"  xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>kotori</title>
    <link>https://raw.githubusercontent.com/Watson1978/kotori/master/sparkle.xml</link>
    <description>Most recent changes with links to updates.</description>
    <language>en</language>
    <item>
      <title><%= title_version %></title>
      <description>
        <![CDATA[
          <ul>
<%= description %>
          </ul>
        ]]>
      </description>
      <pubDate><%= date %></pubDate>
      <enclosure url="https://github.com/Watson1978/kotori/releases/download/v<%= version %>/kotori_<%= version %>.dmg" sparkle:version="<%= version %>" type="application/octet-stream" length="<%= length %>" sparkle:dsaSignature="<%= signature %>" />
    </item>
  </channel>
</rss>
END

desc "Update sparkle.xml"
task :"update:sparkle" do
  require 'erb'
  require 'time'

  signature = `./sign_update ./build/kotori_#{VERSION}.dmg dsa_priv.pem`.strip
  title_version = "Version #{VERSION}"
  version = VERSION
  date = Time.now.rfc2822.to_s
  length = File.size("./build/kotori_#{VERSION}.dmg")

  desc = []
  data = File.read("CHANGES.md")
  data.lines.each do |line|
    line.strip!
    next if line.empty?

    if line.start_with?("##")
      break unless line == "## #{title_version}"
    else
      desc << line
    end
  end
  description = desc.map { |x| x.sub(/^\*\s*/, '') }.map { |x| " " * 12 + "<li>#{x}</li>"}.join("\n")

  erb = ERB.new(sparkle_template)
  File.open("sparkle.xml", "w") { |io|
    io.puts erb.result(binding)
  }
end