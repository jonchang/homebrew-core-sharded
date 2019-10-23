class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.24.3.tar.gz"
  sha256 "c84b3fa140fcd6cce79b3f9de6357c5733a0071e04ca4e65ba5f8d306f10f033"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "163b4a5cf69671c9b1a95d6259169cf8d7d7bb2c5b3f80ab73972f5ae68ef23f" => :catalina
    sha256 "02fe7b10b6077a38871062188058d1392d04bc4f23da7e09e73c52720e00a838" => :mojave
    sha256 "c0fae293caad2ade02191f242cbf33b50283dc850d0c179dcc973ab00e3b60b2" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"

    (buildpath/"third_party/googletest").install resource("gtest")
    system "make", "grpc_cli", "prefix=#{prefix}"
    bin.install "bins/opt/grpc_cli"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
