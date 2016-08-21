class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.38.tar.gz"
  sha256 "8470129f4de9a663702035f15f098766268044bd0052f2a4de5d662990c72d03"

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    pipe_output "#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0
  end
end
