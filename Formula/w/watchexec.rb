class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.11.1.tar.gz"
  sha256 "6d74f336d6734c7625ee5acc5991f14bc0dff8e7cac40cb11303a5ef2f232f5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ac159612e527bef2cc0cabdfd6eeef19263d0faba224371a63f4fdb568d2219" => :catalina
    sha256 "b09275b1c686404ea57e8c0b52c9f2f52b06bc9cbd6b61935e50ca280e902c1c" => :mojave
    sha256 "9bbda6ac49cb30495ec20ed084d08b636a526578a3ec1df8c7e6948c9b7105dc" => :high_sierra
    sha256 "eda530af03c418d4adbd80ae33922d4912df3eae4ecb5695c4692a21d4cc9af5" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
