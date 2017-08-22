class Telnet < Formula
  desc "User interface to the TELNET protocol (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-54.50.1.tar.gz"
  sha256 "156ddec946c81af1cbbad5cc6e601135245f7300d134a239cda45ff5efd75930"

  keg_only :provided_pre_high_sierra

  depends_on :xcode => :build

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      xcodebuild "SYMROOT=build"

      libtelnet_dst = buildpath/"telnet.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    system "make",
      "-C", "telnet.tproj",
      "OBJROOT=build/Intermediates",
      "SYMROOT=build/Products",
      "DSTROOT=build/Archive",
      "CFLAGS=$(CC_Flags) -isystembuild/Products/",
      "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
      "install"

    bin.install "telnet.tproj/build/Archive/usr/bin/telnet"
    man.install "telnet.tproj/build/Archive/usr/share/man/man1/"
  end

  test do
    output = shell_output("#{bin}/telnet 94.142.241.111 666", 1)
    assert_match "Connected to towel.blinkenlights.nl.", output
  end
end
