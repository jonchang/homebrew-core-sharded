class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.3.0.tar.gz"
  sha256 "21b90f9b047a98a4d442795d949952fe687ae14d75cc5f416f1cf77c53e40bca"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfe598be69f1960dbf3168d1f4f18f385ccc771912196fe903f7850426ef8116" => :catalina
    sha256 "99ff8d9c27b9d6fa01c45d91307b73bab26c1245803909f0ebe22eadafdb329d" => :mojave
    sha256 "4f7ecfda2f7bf61a960d53a804a64d89fce3cae3f9c48b1a28e8b75fe435df82" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
