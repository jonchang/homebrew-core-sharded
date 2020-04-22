class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.2.0.tar.xz"
  sha256 "aec8881f236917c4f8064918df546ed3aacd0bb8a2f312f4d37485721cce0fb1"
  revision 1
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    rebuild 1
    sha256 "c0b23e021d21a4fae025734af3e68f3069fa5d5509dd34efca766aea51d58480" => :catalina
    sha256 "2790d10b2a22e34d0659350eb0cc069cc28bb151896c1303d8e0c36b239a1c0a" => :mojave
    sha256 "a28dea05a06b5097a0e847869176ca03b70182ad92727389302a2f60705b1b05" => :high_sierra
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "rpcgen" => :build
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-esx
      --with-init-script=none
      --with-remote
      --with-test
      --with-vbox
      --with-vmware
      --with-qemu
    ]

    args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen" if build.head?

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    mkdir "build" do
      system "../autogen.sh" if build.head?
      system "../configure", *args

      # Compilation of docs doesn't get done if we jump straight to "make install"
      system "make"
      system "make", "install"
    end
  end

  plist_options :manual => "libvirtd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{sbin}/libvirtd</string>
            <string>-f</string>
            <string>#{etc}/libvirt/libvirtd.conf</string>
          </array>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
