class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats/archive/v6.0.1.tar.gz"
  sha256 "10cbac9789b227e844ad47ef563266057f5b7f6ca58d480f46c966e5055694ce"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5057d00e873758234572fe49cca737ee31c562f21bd70c479dfa36b0a0150c82" => :high_sierra
    sha256 "a44278de1034a41a531c04e264af789f0cb3662d921871892dfb5eca798f1c31" => :sierra
    sha256 "961fa0badd4d80a13bf3771aa9c88d6a9318a57686399d1424313dfb00b0d9f3" => :el_capitan
  end

  depends_on "go" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    resource("virtualenv").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin"

    cd "src/github.com/elastic/beats/packetbeat" do
      # prevent downloading binary wheels
      inreplace "../libbeat/scripts/Makefile", "pip install", "pip install --no-binary :all"
      system "make"
      system "make", "update"
      (libexec/"bin").install "packetbeat"
      libexec.install "_meta/kibana"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat*.yml"]
      (etc/"packetbeat").install "fields.yml"
      prefix.install_metafiles
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        -path.config #{etc}/packetbeat \
        -path.home #{prefix} \
        -path.logs #{var}/logs/packetbeat \
        -path.data #{var}/lib/packetbeat \
        "$@"
    EOS
  end

  plist_options :manual => "packetbeat"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/packetbeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/packetbeat", "devices"
  end
end
