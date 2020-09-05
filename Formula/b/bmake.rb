class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200902.tar.gz"
  sha256 "082c0442f03f2dbef8c3171000398c1936047aa0d5a2e1efc2c8474d69403bec"

  livecheck do
    url "http://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 "2fa5a8cd06e9fc40e2478133bc6edf197aa360bec442ce2bff281e675fa2c0a5" => :catalina
    sha256 "d3933ebbaf5ea9e688c7beee9af8052ae959bc484581f011fc14a07de18f0c42" => :mojave
    sha256 "070ccb28e6a32ce2fcc94126a1e186c697311d374cd254a03628224dab25c15f" => :high_sierra
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
