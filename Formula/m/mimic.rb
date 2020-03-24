class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic1/archive/1.3.0.1.tar.gz"
  sha256 "9041f5c7d3720899c90c890ada179c92c3b542b90bb655c247e4a4835df79249"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b61d117b7325e15063e282a223cf9040f8a5b6653cc0d1b2335dbb292e984dca" => :catalina
    sha256 "5637b3526827e1e32d2010ca9a4b1aa2bea53a5a1c5f8f5a1000e74be96b1884" => :mojave
    sha256 "6de781e65c88a019639614c87bd38b59227a2d085b136cf8a63e3d62a7cd0437" => :high_sierra
    sha256 "e10c327921ef68c64fc76915fdec61d3ea210f8874fab2af5ffac14bef8ccdb8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre2" => :build

  depends_on "icu4c"
  depends_on "portaudio"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mimic", "-t", "Hello, Homebrew!", "test.wav"
    assert_predicate testpath/"test.wav", :exist?
  end
end
