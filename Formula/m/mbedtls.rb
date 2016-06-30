class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.3.0-apache.tgz"
  sha256 "590734c8bc8b3ac48e9123d44bf03562e91f8dce0d1ac2615c318c077f3215b2"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd0d1b53b53dc6ed0018315c45523911530c50ad12ee38754f2cde22ba81f180" => :el_capitan
    sha256 "7a4df5593deb57d4ab23d5236aa5957f9ec1e56cf0bc10e538480f3119488a95" => :yosemite
    sha256 "53e89e75891e56b1f0a35fa30be8082a9cd566bb06eb37fd8a9395dd222263ef" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # disable support for SSL 3.0
      s.gsub! "#define MBEDTLS_SSL_PROTO_SSL3", "//#define MBEDTLS_SSL_PROTO_SSL3"
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f "#{bin}/hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install "#{bin}/mpi_demo"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/generic_sum SHA256 testfile.txt").strip
  end
end
