class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20191231.79a5378.tar.gz"
  version "20191231"
  sha256 "c3697593ce2dfdc742bec4cc55848c18c612b1fab8362d5003def834b7056dd2"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6e0a38c8a2af4c8479f8302fef1875d9ad49e1521bfe20a2d57b45b8082ced4" => :catalina
    sha256 "f6e0a38c8a2af4c8479f8302fef1875d9ad49e1521bfe20a2d57b45b8082ced4" => :mojave
    sha256 "832715efbc7a05c38a96a726d02327a28d24b944af247d4645a48cb35eef440f" => :high_sierra
  end

  depends_on "halibut"

  def install
    # Do not build for i386
    inreplace "mkfiles.pl", /@osxarchs = .*/, "@osxarchs = ('x86_64');"

    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
  end
end
