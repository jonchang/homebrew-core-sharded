class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.10.3.tar.gz"
  sha256 "315f8a96253f831100b13584d6d89207d9fd2a7b53823cea5a1a4e3e84d39593"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8955f888b8c0828d741d5541a2ae6567704d78db99600d59b3d9a02dc571089" => :mojave
    sha256 "8711ae0bb727abd3ed3ad8d1335275d26fbc473f19bacfbad76b10b5a0bf4efc" => :high_sierra
    sha256 "a00b82cfce9fecd067b62ec3135a0e9cc59d3133f97ed3c0e7b815e4921c32d0" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
