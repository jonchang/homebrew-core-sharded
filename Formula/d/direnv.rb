class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.25.1.tar.gz"
  sha256 "b6263258490b3c9872db1faaa30e2f5a7981a7f8110e06dea35a8706ed7bf09d"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bb1d9898ddb856409fc29253bebb8a13842b5c4e7e795c0158b14e352ef7ebf" => :big_sur
    sha256 "7c5180938264fe48bc3e10975af1c18a5787e138f22df78c6ab769b429f4e37a" => :catalina
    sha256 "0b94d1d70bd9904bdb6c72674edb3c975500173ceb10a07b63da9382061ee3ca" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
