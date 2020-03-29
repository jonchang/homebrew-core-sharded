class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.2/xmake-v2.3.2.tar.gz"
  sha256 "b189074320ce1b215f85f8f20142fe173d981eb17c2c157f0fa6756fc00dac4e"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "559737626a485e267995fa648059adff6de109837fa0510219e3354e2884d909" => :catalina
    sha256 "bb8ccdd2d63eea78a4e6cd6cce7f1569c9cb17a1b895a0f141dcbe21fa60ccd6" => :mojave
    sha256 "64b7f43e8db1406158be9939f33d102578bbd18b01c9f5a94285e51bd244de83" => :high_sierra
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
