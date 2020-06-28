class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.5/xmake-v2.3.5.tar.gz"
  sha256 "5be491fd023333225ab347dc209f18f453e61d52988ae84f485e1b2552a440d6"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc804b90a7de65ee57b3d110dc94c45895aa70a82f4583b200e447290b73e66" => :catalina
    sha256 "cf59b6c1af7c40ed1f8b3db13cf1c90eb748df41a88fa3240cea8e30813f92f4" => :mojave
    sha256 "71d6cb1de6da0071819d0e6054305d319e16accdf45d1d35c917ef1811896001" => :high_sierra
  end

  on_linux do
    depends_on "readline"
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
