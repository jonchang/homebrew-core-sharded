class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.9.1.tar.xz"
  sha256 "52cd5a0cefaa6be199bf1a8f5295e2ef1f787f9533d1ab9ed1e52d3a242aba6c"

  bottle do
    sha256 "76ace5573bcd26c6031496952807f8e2a0ea8bed4a29a0f7c4d3237ac8a01c8c" => :catalina
    sha256 "ee4843db020afd30ce8c83e661b94d294298ad1d7a7810a1a73c60b4bb6da6df" => :mojave
    sha256 "4d0c802edf008c2206a8611169881928270550cb86305d7b6412cadeb6d21e7f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
