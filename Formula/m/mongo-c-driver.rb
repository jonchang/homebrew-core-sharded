class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.9.5/mongo-c-driver-1.9.5.tar.gz"
  sha256 "4a4bd0b0375450250a3da50c050b84b9ba8950ce32e16555714e75ebae0b8019"

  bottle do
    cellar :any
    sha256 "593189006ea209f85d5abe47d202cf00a1372fa7fe940fb520dfd93034233a96" => :high_sierra
    sha256 "2f38f204bd511a0950b6837e444065415bf3f1f38e30e233f4cf1457819caf73" => :sierra
    sha256 "fb9688c0c130589d978caf63b4cc9943d2c288a0a3ee1240a4601ad243127037" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "autoreconf", "-fiv"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man-pages
      --with-libbson=bundled
      --enable-ssl=darwin
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"mongoc").install "examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"mongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
