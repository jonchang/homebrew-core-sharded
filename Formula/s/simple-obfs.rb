class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev"
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs.git",
      :tag => "v0.0.4",
      :revision => "917411a3ab0cbe8d136ae4bbd8461f3775c182b8"

  bottle do
    cellar :any
    sha256 "9ea5d15e2212cf770cd84835f1120bdb1d50356647d3dce08ceefbd253f9e9a0" => :high_sierra
    sha256 "607e8f54808f464b6c5ec740c95889516cbd67fdd93a459479a9f9a57c6ef65e" => :sierra
    sha256 "0cc5634c25b3cea1801b1896c265e1bd9acb932d3c1081a9d930430c076f378d" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "c-ares"
  depends_on "libev"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-applecc"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "simple-obfs", shell_output("#{bin}/obfs-local -h 2>&1")
  end
end
