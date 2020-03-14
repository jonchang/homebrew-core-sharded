class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.30.0.tar.gz"
  sha256 "25915cbd33a9f53c89ddf7fbd68fccc5ffc89ab40d4445ccc813da74fae154f2"

  bottle do
    cellar :any
    sha256 "bf8e0b58ad49024b24191105f2131c40dc992ed47c3e7cfeeebfb94c00a20e65" => :catalina
    sha256 "bc659ae1f3838a1db82ea7526420547020af3504f4a24ae9cae86d3eef9f83c1" => :mojave
    sha256 "b13b8b91a70e48ef89f815fa97eae696bca5748b739a516736c847425d58010b" => :high_sierra
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "DEBUG=no", "HOMEBREW=1", "USE_UPNP=yes",
                              "USE_AENSI=no", "USE_AVX=no", "PREFIX=#{prefix}"

    # preinstall to prevent overwriting changed by user configs
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path doesn't exist,
    # create the directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must recreate symlinks
    # to the latest version on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf",
                              etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  plist_options :manual => "i2pd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/i2pd</string>
          <string>--datadir=#{var}/lib/i2pd</string>
          <string>--conf=#{etc}/i2pd/i2pd.conf</string>
          <string>--tunconf=#{etc}/i2pd/tunnels.conf</string>
          <string>--log=file</string>
          <string>--logfile=#{var}/log/i2pd/i2pd.log</string>
          <string>--pidfile=#{var}/run/i2pd.pid</string>
        </array>
      </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/i2pd", "--datadir=#{testpath}", "--daemon"
    end
    sleep 5
    Process.kill "TERM", pid
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
  end
end
