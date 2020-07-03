class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.16.1.tar.bz2"
    sha256 "c91f3a2f7b02db0f3bc99479861656154d241d2fdb265614ba918cc6720a33ca"

    depends_on :maximum_macos => :high_sierra
  end

  bottle do
    sha256 "52f01d383ca2a8515840aeef2af133a7f12ced48bc0077e01de71b5eb7c44b04" => :high_sierra
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-only64bit
      --build=amd64-darwin
    ]
    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
