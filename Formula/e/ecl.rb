class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
  revision 4
  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "1b22aba62174f0ee17ddbc8913522463d25647daab83f02de3c924230e61b66b" => :catalina
    sha256 "4e28aab0c72dbb411b27b7b0bc92c6277c02170fab0dfe96c0ad84c19fbd0381" => :mojave
    sha256 "315810b954020ffde49b5386e789d49640f4a3018fac98e8f2f76aab8b3b0258" => :high_sierra
  end

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
