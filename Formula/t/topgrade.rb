class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.3.0.tar.gz"
  sha256 "5d7e4322098d69b3de976e30c70cfdf1afa05167ead0432aea2e92c67d03108c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bed6f7d98b8f4c4ab53218e9ceec035cd455838d3ac148b67e9d552d3eb4606" => :mojave
    sha256 "a7f7d68d3fcdc05ba7e73b3204a656daf6d6a9c58d694c1bdc3e299ccfb38b13" => :high_sierra
    sha256 "20f9831ee1aa544d0b267c8e7ef115a5bc6fcce7044901888015715dc5a4af5a" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
