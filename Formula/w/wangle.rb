class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2020.11.02.00/wangle-v2020.11.02.00.tar.gz"
  sha256 "fb2b48c7ae09d8fff361c0c5e96bd839f9fe99fd0ffce28939dd8a81388fa42b"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "lib/libwangle.a"

      pkgshare.install Dir["example/echo/*.cpp"]
    end
  end

  test do
    cxx_flags = %W[
      -std=c++14
      -I#{include}
      -I#{Formula["openssl@1.1"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]

    system ENV.cxx, *cxx_flags, "-o", "EchoClient", pkgshare/"EchoClient.cpp"
    system ENV.cxx, *cxx_flags, "-o", "EchoServer", pkgshare/"EchoServer.cpp"

    port = free_port

    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 2

    require "pty"
    r, w, pid = PTY.spawn(testpath/"EchoClient", "-port", port.to_s)
    w.write "Hello from Homebrew!\nAnother test line.\n"
    sleep 1
    Process.kill("TERM", pid)
    output = r.read
    assert_match("received back: Hello from Homebrew!", output)
    assert_match("received back: Another test line.", output)
  end
end
