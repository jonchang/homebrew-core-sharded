class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.7/zsh-5.7.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.7.tar.xz"
  sha256 "7807b290b361d9fa1e4c2dfafc78cb7e976e7015652e235889c6eff7468bd613"

  bottle do
    rebuild 1
    sha256 "807b44a6f1c3468cbc853383770384630acb32681ef4a2259f2d4224ec7e280e" => :mojave
    sha256 "7c45d08186d58959039441892909a645c36408966f51ed1051b3f00e3fcda8a0" => :high_sierra
    sha256 "040db78ee0c3a141f57db8f91c7458f1244c5beb2238a672e792de4304d7a751" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.7/zsh-5.7-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.7-doc.tar.xz"
    sha256 "f0a94db78ef8914743da49970c00fe867e0e5377fbccd099afe55d81a2d7f15d"
  end

  def install
    system "Util/preconfig" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-fndir=#{pkgshare}/functions",
                          "--enable-scriptdir=#{pkgshare}/scripts",
                          "--enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions",
                          "--enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts",
                          "--enable-runhelpdir=#{pkgshare}/help",
                          "--enable-cap",
                          "--enable-maildir-support",
                          "--enable-multibyte",
                          "--enable-zsh-secure-free",
                          "--enable-unicode9",
                          "--enable-etcdir=/etc",
                          "--with-tcsetpgrp",
                          "DL_EXT=bundle"

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    if build.head?
      # disable target install.man, because the required yodl comes neither with macOS nor Homebrew
      # also disable install.runhelp and install.info because they would also fail or have no effect
      system "make", "install.bin", "install.modules", "install.fns"
    else
      system "make", "install"
      system "make", "install.info"

      resource("htmldoc").stage do
        (pkgshare/"htmldoc").install Dir["Doc/*.html"]
      end
    end
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/zsh -c 'echo homebrew'").chomp
    system bin/"zsh", "-c", "printf -v hello -- '%s'"
  end
end
