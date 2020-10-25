class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.3.tar.gz"
  sha256 "463efc219af8e77eb0b0d183feaa357f4d8e7c3813382055ef262c91a0c44092"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  bottle do
    sha256 "e108fa748c1338a788d4a88bcd94e826d95c721776049168461a371d3536c94a" => :catalina
    sha256 "2f9abacbf14fac154ae4e4c46b49e058f1552246ff9397641057d48a931ad5f9" => :mojave
    sha256 "7fb1fc3474a531602e3123b354b8fc6733eec5dcefc0bc21a4d0a1d11d3cb77a" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    assert_equal pipe_output("#{bin}/osh -c 'pwd'").strip, testpath.to_s
  end
end
