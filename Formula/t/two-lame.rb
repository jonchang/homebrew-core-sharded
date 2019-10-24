class TwoLame < Formula
  desc "Optimized MPEG Audio Layer 2 (MP2) encoder"
  homepage "http://www.twolame.org/"
  url "https://downloads.sourceforge.net/twolame/0.4.0/twolame-0.4.0.tar.gz"
  sha256 "cc35424f6019a88c6f52570b63e1baf50f62963a3eac52a03a800bb070d7c87d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "98a0ad3cf35a49fa67c88f0e0fc5cd129abcc2ee1083576d1a181340cecbed1d" => :catalina
    sha256 "3e1206ffe2663c75cc8def2832a0b36374bd1c548f234e178462219536abf539" => :mojave
    sha256 "34e26fc01f8c195e0b410bf3756cb283d86417f1b1d4ec0ac799441976601f78" => :high_sierra
    sha256 "f1138207ebf9a6e1a95ebd553b3f7a8c91ba7546d812c313fa1f3beac8d593c9" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "simplefrontend/.libs/stwolame"
  end

  test do
    system "#{bin}/stwolame", test_fixtures("test.wav"), "test.mp2"
  end
end
