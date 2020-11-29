class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/v1.0.1.tar.gz"
  sha256 "8275c02c903e49d3d6bf30b3d3a279d00a8c3ef4ac9e13e406f19a81356ec5af"
  license "MIT"
  head "https://github.com/orf/gping.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7e6198d7fb3672bdb10ecea486f23079509e24c004353bfbae99a5f3eef58ba9" => :big_sur
    sha256 "bc93f9061547e8c527150b71e534fba354ed361aa464ef01b574af9a0b634e73" => :catalina
    sha256 "5fd58669e8798a148cda01087c9b4beb957751320ac0207de12ecbe69c4d9164" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub! /\e\[([;\d]+)?m/, ""

    assert_match "google.com (", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
