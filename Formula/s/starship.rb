class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.39.0.tar.gz"
  sha256 "8ebeaf2f238d0513f97eeeecc1214b4f22b3431f2fc4ed0d9afd3868b4dd3c17"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac6040dd41502ce7d70cc74843e03ffdfc67e5537cf1b13d26cba672330b4f36" => :catalina
    sha256 "0cde50c6993ff05cbd3baa3470f04031f21cfc26dbdc7fc33aecb55fd2018c57" => :mojave
    sha256 "4b14c262a6a4db3b86b040794c63da6cc931c68cbe306eae922e61ac13ca7f14" => :high_sierra
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
