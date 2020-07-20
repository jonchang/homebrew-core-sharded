class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.2/avfs-1.1.2.tar.bz2"
  sha256 "b69339d3602221bc381fd7528e6dda4b23522f825781638be3fa7d9b8837ab0c"

  bottle do
    sha256 "f060170581f703385397ce01f126fb01edf74f97fc3a5a2d889ecfb6464f403c" => :catalina
    sha256 "e9f048f1f3f156b62c0650d07b51e82020a896538a51fdffd2ae06bf2d661380" => :mojave
    sha256 "4ca7d845c2b2e3c066c2441490b7e9588ef727ab0815aee57c5321ad826435df" => :high_sierra
    sha256 "9dd4c35adcc1c1350b48f0a37130414370b38c63a886a0b1824838da34a16c97" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "openssl@1.1"
  depends_on :osxfuse
  depends_on "xz"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    # This fix is already present in upstream but so far unreleased
    # https://sourceforge.net/p/avf/git/ci/ea83e0559f65ab89e81b4105e38b39a40cf9900e
    inreplace "modules/urar.c", "#include <unistd.h>", "#include <unistd.h>\n#include <limits.h>"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
