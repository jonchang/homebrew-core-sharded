class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit.git",
      :tag => "urbit-0.6.0",
      :revision => "7633b5cc9cf249d873f16f08c09a1ee10a4f24d2"

  bottle do
    cellar :any
    sha256 "3ea8320910d59da1d22253cda85376570636e0c65f4d78b0ad7b79f1e9400923" => :high_sierra
    sha256 "6aa8484fbfaa20cd2b2b53b8de1cea7b342fe2a34185a91a680d6d544ac93d1f" => :sierra
    sha256 "fa9109dff4cde264e6581f81e9bd30574081fd94ebff4436888d77460db4b8ad" => :el_capitan
    sha256 "5544b9553137481df6e2035a4e0a0b022f362fab12f2b3047cc206a93f79cc5c" => :yosemite
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl"
  depends_on "re2c"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
