class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://www.neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180223.tar.gz"
  sha256 "10ba010017cf7db6bb5ac3e2116d6defad56d34be0dceea9d70a66d8510927bb"
  revision 1
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "c00efc604fc47b33502594bd164190e0864bf12b2d6490074529d4c38a92ffad" => :high_sierra
    sha256 "50a45599e372e0662306f4fb4b5a49cdfaf9e13a3bb25fce4992e3177b734244" => :sierra
    sha256 "089407d9e5b6743ad574e259e3a7efa7179f6ae16cd9594c4bdcafff2cf626f0" => :el_capitan
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "notmuch"
  depends_on "openssl"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "debug_level=0", output.chomp
  end
end
