class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.35.1.tar.gz"
  sha256 "22b4bf8bfe45d492d69433942e02731b141091f11b03860cb02d21f4f2431285"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03149150dc074be301cc81e231b573ba6c6bba1cda45f9e8ff476c297b57a7dc" => :catalina
    sha256 "4cb4704e08f33366edb4e4bdb7607d7390f507cda4e461c0d895cfc0cafbdef3" => :mojave
    sha256 "231c4656de41a9fb82fff6d50d9019cd08c354033d573543eb4f77bfa66d3c62" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
