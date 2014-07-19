require "formula"

class Unpaper < Formula
  homepage "https://www.flameeyes.eu/projects/unpaper"
  url "https://www.flameeyes.eu/files/unpaper-5.1.tar.xz"
  sha1 "97068a99d47d1d65030c88d52058c1d5ff7b41d1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
