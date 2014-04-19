require 'formula'

class Memcached < Formula
  homepage 'http://memcached.org/'
  url 'http://www.memcached.org/files/memcached-1.4.18.tar.gz'
  sha1 'e550ac63f1accb2c4b8384fd200a79a7e574b364'

  bottle do
    sha1 "9659921b7f83252f74fd71c9d89b0f087a987c39" => :mavericks
    sha1 "56150a0077821d1758073238e8bac39f0028b6df" => :mountain_lion
    sha1 "f0b6c864165782512b716f71853f6e24d57fdbda" => :lion
  end

  depends_on 'libevent'

  option "enable-sasl", "Enable SASL support -- disables ASCII protocol!"
  option "enable-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"

  conflicts_with 'mysql-cluster', :because => 'both install `bin/memcached`'

  def install
    args = ["--prefix=#{prefix}", "--disable-coverage"]
    args << "--enable-sasl" if build.include? "enable-sasl"
    args << "--enable-sasl-pwdb" if build.include? "enable-sasl-pwdb"

    system "./configure", *args
    system "make install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/memcached</string>
        <string>-l</string>
        <string>localhost</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end
end
