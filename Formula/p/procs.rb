class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.2.tar.gz"
  sha256 "224c73420f5fbffbf48be146d9e93901eb1bea1a90fc84551eb6cd72c28a7a34"

  bottle do
    cellar :any_skip_relocation
    sha256 "7407ff757136c071c07ed1d604242f98a82ed9b2e2466e7b176b1b1226fc1339" => :catalina
    sha256 "170081d604733bb6fa86ccf599dbd7feddedcfce7c767eb438c89f49c2c6010b" => :mojave
    sha256 "a42ad2cf8b274cc0ed0b1b978b6896afadf4b2956836beacf994abb9455aa54c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
