class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 5
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git"

  bottle do
    cellar :any
    sha256 "110c82493cedbf7b5c1ba0840eb5a01d33ace587db01fc1ed4e9707073a21322" => :mojave
    sha256 "5fb50e2d8436ef85aa47efca7494e0d25f43e46a1f66895d1457771a65b08f6b" => :high_sierra
    sha256 "5bd541db8f60a4f6a432794c800c8a6fc68cd74e5a96ca6547bdfc5cc64e4b1f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg"
  depends_on "libkate"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  # Use python3 print()
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/master/debian/patches/0002-Use-python3-print.patch"
    sha256 "8cf333e691cf19494962b51748b8246502432867d9feb3d7919d329cb3696e97"
  end

  def install
    # Fix unrecognized "PRId64" format specifier
    inreplace "src/theorautils.c", "#include <limits.h>", "#include <limits.h>\n#include <inttypes.h>"

    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
      "APPEND_LINKFLAGS=-headerpad_max_install_names",
    ]
    system "scons", "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
