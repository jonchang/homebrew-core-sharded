class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_90.tar.gz"
  sha256 "9bed0a307e3f4782402b5944426f298dbad0028a93c83068ef10af9e3ff27e2b"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "522b1373e4609d0c48a5a962f749d04e3a384163650a41e48c3ecc19cb7e9fee" => :catalina
    sha256 "503f08001df55166e8728d7ee13fa2791216cea8e5aef1dee3ff2ba88024861a" => :mojave
    sha256 "e78a30567703250a3643b415adb5f53b2a05e7a915945fc2d70284ee6adff352" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end
