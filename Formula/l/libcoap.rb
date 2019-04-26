class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.2.0.tar.gz"
  sha256 "9523e38da6ee8b2a8f5ce83ded64107dd1e514c7ad00cd74ccfe3454b679c271"

  bottle do
    cellar :any
    sha256 "d83c195d5b9acd81c7a91a3115ef8ac9783baefd48cdf63396c74cefcf4ecbd7" => :mojave
    sha256 "0c6f38dbbdca258949c72b8eb9439e72c9f8cdb473de80fc4b2d5996a89d80b5" => :high_sierra
    sha256 "f9577ef79f4c1a7a257d04004cb64802879787bb5b5657a7aa54ab24ee102c20" => :sierra
    sha256 "a8b3fe01f85e8d9345dbe4ceddda24abd244f1b4055abcfef36e73b26e14ae86" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1" if MacOS.version <= :sierra

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-manpages"
    system "make"
    system "make", "install"
  end
end
