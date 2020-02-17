class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.20.0/ldc-1.20.0-src.tar.gz"
  sha256 "49c9fdfe3a51c978385aae94f2e102f306102f6282215638f2ae3fb9ea8d3ab9"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "7e077231af630a790d89b1694cbe9e4fb7aa0d524bbbbf485187233c15ce4617" => :catalina
    sha256 "4f106e8ac37f77d1c08bdcfee198cdf8f5272b2d596ba80a65b2e5db3a34ab8c" => :mojave
    sha256 "e5b83310430be855384c6d8a37d83d03f1bcae500836f796f8c54c38c80db603" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.20.0/ldc2-1.20.0-osx-x86_64.tar.xz"
    version "1.20.0"
    sha256 "00827edaf43b4f7a3bf5117d2a6b8cb3cae0e7b167782d2d41bce078804fc769"
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
