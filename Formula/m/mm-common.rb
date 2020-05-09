class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.0.tar.xz"
  sha256 "b97d9b041e5952486cab620b44ab09f6013a478f43b6699ae899b8a4da189cd4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "306e6e16c9ae197a492b8471fbfe8545709ba38b8deaa123cbea6739eeb8b807" => :catalina
    sha256 "306e6e16c9ae197a492b8471fbfe8545709ba38b8deaa123cbea6739eeb8b807" => :mojave
    sha256 "306e6e16c9ae197a492b8471fbfe8545709ba38b8deaa123cbea6739eeb8b807" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    mkdir testpath/"test"
    touch testpath/"test/a"

    system bin/"mm-common-prepare", "-c", testpath/"test/a"
    assert_predicate testpath/"test/compile-binding.am", :exist?
    assert_predicate testpath/"test/dist-changelog.am", :exist?
    assert_predicate testpath/"test/doc-reference.am", :exist?
    assert_predicate testpath/"test/generate-binding.am", :exist?
  end
end
