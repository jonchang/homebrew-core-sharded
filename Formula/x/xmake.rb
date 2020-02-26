class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.1/xmake-v2.3.1.tar.gz"
  sha256 "4b1b46233d84259a66bc112d05513feae2507f1b30b4c2a494c4bdf84e5845dd"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "060a9e262ac2abb340f7c6329c9bad9dc0926015e863da2b5f6af504884eb0ab" => :catalina
    sha256 "1de44a55ca9e37aa4e863bb027925d72a9f1975a7131048dd32bebb7d470f9f1" => :mojave
    sha256 "f5d7779349809fe9f06ffca861a121ad1face3b00bf871079abd336e8fe9fec3" => :high_sierra
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
