class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
      :tag => "v0.14.6",
      :revision => "7569b75d61cb7a1f964f09aafa1c87d86554f377"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09d3a0b66a6643a9136a7bd216fd8b30ff3183bd1daa4f02177cb6f53f4eb9df" => :sierra
    sha256 "02cbac96d24ac588ccdabce4d6efad19021f5b3dce5ab10f59ce2ea745dd26c4" => :el_capitan
    sha256 "cc4d57d7a45f4850fb472b03893fdbf923e3653ea4e4302134981dc95e590c23" => :yosemite
    sha256 "870d9c12ce63d6985fd9adee6b016203788411ae4fad6e87a78ecbd230224a27" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/".syncthing-gopath"
    mkdir_p buildpath/".syncthing-gopath/src/github.com/syncthing"
    cp_r cached_download, buildpath/".syncthing-gopath/src/github.com/syncthing/syncthing"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    cd buildpath/".syncthing-gopath/src/github.com/syncthing/syncthing"
    system "./build.sh", "noupgrade"
    bin.install "syncthing"
  end

  plist_options :manual => "syncthing"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/syncthing</string>
          <string>-no-browser</string>
          <string>-no-restart</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>Crashed</key>
          <true/>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
