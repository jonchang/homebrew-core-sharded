class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://github.com/starship/starship"
  url "https://github.com/starship/starship/archive/v0.10.1.tar.gz"
  sha256 "ef09ad28ef73619b7d86bc6c5713a2e423c1fa4d6403c2983e8692e6b4fc2a98"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "ed28daf8b052340bbd6f7878f2de69c4cf3c73cd0f4c0effddc1d15eb8d68b6a" => :mojave
    sha256 "a29dd96ad7b264023d5e0ff057c8227fe0c3b0ec4f7e011c821153a17b166519" => :high_sierra
    sha256 "7ce07ba7d4292b0d5c465661ca6a09f9306465bdbca58de74070ca982c78d36e" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m➜[0m ", shell_output("#{bin}/starship module character")
  end
end
