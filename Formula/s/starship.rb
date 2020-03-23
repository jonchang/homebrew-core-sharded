class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.38.1.tar.gz"
  sha256 "3eb01abfa038994ed24d520bfabbb30273ed90909ee87b58a854d92ad5a6db9a"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb42b5ac227280bb6dafe0f7c1f70851cde6273a375461d201f94c96777c87ca" => :catalina
    sha256 "d9a07177b9b2af743fb294cc391a79df0327e11c9848874e3b170b7ab7a5458c" => :mojave
    sha256 "14ac37580fb454c23e8d2c6d1a916dc7ea43b60c880012a51c7b0bc8a22549f7" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
