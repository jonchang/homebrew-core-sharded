class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.2.0.tar.gz"
  sha256 "4a1ffdc20e0f501e3bd953421c4a1e09a852717408dcb6b8a387bbe8f41e8f1d"

  bottle do
    sha256 "5cbcce4556b41ece91f01778068f481514bc3a0d5447ddbff048797236cc9b29" => :mojave
    sha256 "15748ef1ffefa088f7c958e6935c6eec794781858e6190196e18e94ab768adc2" => :high_sierra
    sha256 "49eb0e5d27b8868b2dba20efbde3ef75becc0cbf5ea230c00e5745e2df697cb6" => :sierra
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
