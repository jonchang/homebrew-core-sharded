class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.10.0/libfabric-1.10.0.tar.bz2"
  sha256 "c1ef6e9cd6dafec3f003d2f78f0f3a25f055a7a791e98b5a0db1e4c5036e40f6"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "8d2368705fbf1afd50ea10508d987396576fd4b3d43b036c36cb272c3370ffa6" => :catalina
    sha256 "014f3a1e5aaedfdd997bd4c57324144052c549b5441b70cac0f45c408b7a5177" => :mojave
    sha256 "e594d5b93f0f2ce539995834049d8d6698114432382ec3d9d93f795c43427615" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
