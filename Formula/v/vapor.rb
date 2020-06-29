class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.0.0.tar.gz"
  sha256 "1d1b72d92dfb4e417dbbfe8486149f64a92cbfcf86db5209686fdd926b43c74c"
  head "https://github.com/vapor/toolbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7762239037cff59e33be03863b68cccc19580db9414b1f4bdb012f16df0d2fb" => :catalina
  end

  depends_on :xcode => "11.4"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", \
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system "vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
