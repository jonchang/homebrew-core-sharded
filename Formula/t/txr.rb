class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-233.tar.bz2"
  sha256 "a12e7769c1f3354f6c85bc1d26a3cb2de548e45ac7ae38b982e74163b19148d8"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "ae02c2579cd93bb188aaec1cb801c894245098761358b5bfb4d40b49a4505f77" => :catalina
    sha256 "facfed24452bdb1e07344788fc839d9c9acc553a666f1849b653aaf4eae06fc2" => :mojave
    sha256 "31f4399f13d8ca162c10db32c81f17f3ea0a876c6e72351566c5be7c18ac9530" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
