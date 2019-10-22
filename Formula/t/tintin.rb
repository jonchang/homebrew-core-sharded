class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.91.tar.gz"
  sha256 "3596a6d540d58162dc60c318c520cb94ee52fb438b5db8a2fa2513c47fbe6359"

  bottle do
    cellar :any
    sha256 "8d956b49533c34fe0ac3006440c294e28ecca2d5b35bedad910cd92c40b7aced" => :catalina
    sha256 "f149950448a3c8fd4af7af4cd741ec501688da1ada83f0d461f853997fd1542b" => :mojave
    sha256 "5d34258b43da14466fa7d4e901295b30d805b84c487294d9dafeb5faf61000c7" => :high_sierra
    sha256 "e3a066af9d699b30ad7e084c2403bd97df8116560fcbc33002214f7d7ebd47f4" => :sierra
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"tt++", "-G", "input") do |r, _w, _pid|
      assert_match "Goodbye", r.read
    end
  end
end
