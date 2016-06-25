class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.8.9.tar.gz"
  sha256 "cff21ca654056bed08781c5e462966f5f15acec7b6522191d286dee3339e327e"

  bottle do
    revision 1
    sha256 "f9699b28c53f744b7b4701890739d7a9369a6e0b144d486d7fee27ed4b4a9486" => :el_capitan
    sha256 "7490e2e4026fca6442fce8c6f56d654deb45ba864ca6b7a73872d670b4475d49" => :yosemite
    sha256 "60d59e09f4a440cffeb077f1de14784519223e6f25ccaaf6df692dc63fd6cac8" => :mavericks
  end

  head do
    url "https://github.com/arangodb/arangodb.git", :branch => "unstable"
    depends_on "cmake" => :build
  end

  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    ENV.libcxx

    if build.head?
      mkdir "arangodb-build" do
        system "cmake", "..", "-DHOMEBREW=On", "-DUSE_OPTIMIZE_FOR_ARCHITECTURE=Off", "-DASM_OPTIMIZATIONS=Off", "-DETCDIR=#{prefix}/etc", "-DVARDIR=#{var}", *std_cmake_args
        system "make", "install"
      end

    else
      # clang on 10.8 will still try to build against libstdc++,
      # which fails because it doesn't have the C++0x features
      # arangodb requires.
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
        --disable-relative
        --datadir=#{share}
        --localstatedir=#{var}
      ]

      args << "--program-suffix=-unstable" if build.head?

      if ENV.compiler != :clang
        ENV.append "LDFLAGS", "-static-libgcc -static-libstdc++"
      end

      system "./configure", *args
      system "make", "install"
    end
  end

  # moving the "if" inside post_install does not work
  if build.head?
    def post_install
      (var/"lib/arangodb3").mkpath
      (var/"log/arangodb3").mkpath
    end
  else
    def post_install
      (var/"arangodb").mkpath
      (var/"log/arangodb").mkpath

      system "#{sbin}/arangod", "--upgrade"
    end
  end

  def caveats
    s = <<-EOS.undent
      Please note that clang and/or its standard library 7.0.0 has a severe
      performance issue. Please consider using '--cc=gcc-5' when installing
      if you are running on such a system.
    EOS

    if build.head?
      s += <<-EOS.undent
        A default password has been set. You can change it by executing
          #{sbin}/arango-secure-installation
      EOS
    end

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_equal "it works!\n", shell_output("#{bin}/arangosh --javascript.execute-string \"require('@arangodb').print('it works!')\"")
  end
end
