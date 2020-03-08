class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.4.1.tar.gz"
  sha256 "d9450fe50e15da7dc5c577d600f94945c667f0867f34badf1ef845abb5e65b38"
  head "https://github.com/cbednarski/hostess.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2c61fc463c4fd3eb01f39113691c9e125d50e94adca735147983d04727e3266" => :catalina
    sha256 "6cfdc19ffaa808405e9fde6fa69825cdd9b2cbeaae7a44d67f8bbc2a14d8680d" => :mojave
    sha256 "dd48ab07035f029439d5fe413304306aa6ef64a0d6dfcba2fd3f3814e15cdd07" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"hostess"
  end

  test do
    assert_match "localhost", shell_output("#{bin}/hostess ls 2>&1")
  end
end
