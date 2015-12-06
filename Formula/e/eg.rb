class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "https://github.com/davep/eg"
  url "https://github.com/davep/eg/archive/eg-v1.01.tar.gz"
  sha256 "bb7a2af37c8d5d07f785466692f21561257ff99106d2cb91db13ba2e946ff13b"
  head "https://github.com/davep/eg.git"

  depends_on "s-lang"

  def install
    inreplace "eglib.c", "/usr/share/", "#{etc}/share/"
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}", "NGDIR=#{etc}/norton-guides"
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success if the file doesn't
    # exist, without popping into the UI - we're exploiting this here.
    ENV["TERM"] = "xterm"
    system bin/"eg", "not_here.ng"
  end
end
