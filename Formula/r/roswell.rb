class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v20.01.14.104.tar.gz"
  sha256 "798b96fdcb8c89445b36692b31570bb99882d83719d6310d969ccfcb2a35a1d4"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "f6987b7b0d0570fbd3ff47ba08d73d4c4c94b1673b07fe207ac0920fd0c36584" => :catalina
    sha256 "bafa194c7c9b4c15459360fb6f4e8b98288144841a988af90cdca1ff3c17841e" => :mojave
    sha256 "c2f9daad6c90d52c45eae23c3dc2f15501d2ecab2767565b4a07d7cc1462929e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
