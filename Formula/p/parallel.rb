class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20181122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20181122.tar.bz2"
  sha256 "2f06580c833ca30f434511ea28a0c097e75e3ee35a87b3a58512bd6d5cf598d5"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f554dc0c5acc329c6aa09b5cea696611f2d361d9425075325db0704dcb7f59aa" => :mojave
    sha256 "5e76c786e5f9561f09e4598d8e43f4ecabeb103fbdd9a2a3e7c14b0d39769274" => :high_sierra
    sha256 "5e76c786e5f9561f09e4598d8e43f4ecabeb103fbdd9a2a3e7c14b0d39769274" => :sierra
  end

  if Tab.for_name("moreutils").with?("parallel")
    conflicts_with "moreutils",
      :because => "both install a `parallel` executable."
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
