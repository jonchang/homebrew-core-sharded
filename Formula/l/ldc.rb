class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.17.1/ldc-0.17.1-src.tar.gz"
  sha256 "8f5453e4e0878110ab03190ae9313ebbb323884090e6e7db87b02e5ed6a1c8b0"

  bottle do
    sha256 "2de136bd7d32035ab020e2baa8adc4f6bced37aa4a14f721ab7065dd4b572a03" => :el_capitan
    sha256 "b4753490e35a5698f5f17ead17f12f58ca698a6c27418135692c781efae2b3dd" => :yosemite
    sha256 "da22d9b923b89baab0ccec0801827d709ed0ddafbc514ac9b0bd87d28b21b1ff" => :mavericks
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.0.0-alpha1/ldc-1.0.0-alpha1-src.tar.gz"
    sha256 "b656437d0d7568c5ac4ef4366376184c06013e79f3dd5a512b18ca9f20df4b63"
    version "1.0.0-alpha1"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.1/ldc-0.17.1-src.tar.gz"
      sha256 "8f5453e4e0878110ab03190ae9313ebbb323884090e6e7db87b02e5ed6a1c8b0"
    end
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git", :shallow => false, :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libconfig"

  def install
    ENV.cxx11
    if build.stable?
      mkdir "build" do
        system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", *std_cmake_args
        system "make"
        system "make", "install"
      end
    else
      (buildpath/"ldc-lts").install resource("ldc-lts")
      cd "ldc-lts" do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args
          system "make"
        end
      end
      mkdir "build" do
        system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", "-DD_COMPILER=../ldc-lts/build/bin/ldmd2", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    system "#{bin}/ldc2", "test.d"
    system "./test"
    system "#{bin}/ldmd2", "test.d"
    system "./test"
  end
end
