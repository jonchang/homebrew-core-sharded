class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.28.4.tar.gz"
  sha256 "bab1cabb0542ce2bd4b41a15b84a8d81c8dc3332162705ded6f311dd898656ca"
  revision 1
  head "https://git.notmuchmail.org/git/notmuch", :using => :git

  bottle do
    cellar :any
    sha256 "f89b7820070e0b413ef73d269fa32af76791d2f5c1ddbeb7fad7da3c38812335" => :mojave
    sha256 "554f9712f655b4af2245cb5b52b5f12c06e31e5bcb2b96f9799bbe6072ad7329" => :high_sierra
    sha256 "d9d421913f0628fa0539b9d6a0f9a811c15200f3826e84682dfb513c66544511" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "emacs"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@2"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-emacs
      --emacslispdir=#{elisp}
      --emacsetcdir=#{elisp}
      --without-ruby
    ]

    # Emacs and parallel builds aren't friends
    ENV.deparallelize

    system "./configure", *args
    system "make", "V=1", "install"

    cd "bindings/python" do
      system "python2.7", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
