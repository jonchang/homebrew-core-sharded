class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.28.0.tar.gz"
  sha256 "b3279f9b6abbd1ec98c8ef480ab1a11056f7f06a3f75deeb215c82185f4c33e2"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0af14cbb74873d2b6ff6844b2eb051fc112646693830c0e878ea5bb3cd77df52" => :catalina
    sha256 "48ce8734e05a7df1eded465cdda05e8617379f249101418cf0d9b781eab9e8cb" => :mojave
    sha256 "337fe0a19091bac546d03e5cd5fb8c6be587992553289ad80c34e2dbb53c6261" => :high_sierra
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
