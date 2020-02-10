class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.4.0.tar.gz"
  sha256 "6a73dccb9bd55e13e3bf3d9327eb535c8bdb619cfc08ebaed4e7d3061548f187"

  bottle do
    cellar :any_skip_relocation
    sha256 "e92099c2374b8a86f4ff76f4105821c2ce8aecf102cf7b0dcb925801579f23cd" => :catalina
    sha256 "01fcce15c3da9c8e176d32baaaf0a8eefc06185022ccc640e925e607e9c2efc9" => :mojave
    sha256 "417a48bb132239887fd8fbdd04a97e3800dbca921e60d0b4ba92b24049be736a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
